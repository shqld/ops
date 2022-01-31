package main

import (
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os/exec"

	"github.com/google/go-github/v42/github"
)

func main() {
	http.HandleFunc("/webhook/github", handleWebhookGithub)

	log.Println("server listening at 7000")

	log.Fatal(http.ListenAndServe(":7000", nil))
}

func handleWebhookGithub(w http.ResponseWriter, req *http.Request) {
	log.Println(req.Method, req.URL)

	if req.Method != "POST" {
		http.NotFound(w, req)
		return
	}

	io.WriteString(w, "Hello, world!\n")

	payload, err := ioutil.ReadAll(req.Body)
	if err != nil {
		log.Printf("could get response body: err=%s\n", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	webhook_type := github.WebHookType(req)

	log.Println("webhook_type", webhook_type)

	event, err := github.ParseWebHook(webhook_type, payload)
	if err != nil {
		log.Printf("could not parse webhook: err=%s\n", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	switch event := event.(type) {
	case *github.WorkflowRunEvent:
		err = handleWebhookGithubWorkflowRunEvent(w, event)
	case *github.PushEvent:
		err = handleWebhookGithubPushEvent(w, event)
	}

	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}

func handleWebhookGithubPushEvent(w http.ResponseWriter, event *github.PushEvent) error {
	repo := event.GetRepo()

	if repo.GetFullName() == "shqld/ops" && event.GetRef() == "refs/heads/main" {
		wallMessage("shqld/agent: updating /ops ...")

		log.Printf("running: 'git diff --exit-code --quiet'\n")
		out, err := exec.Command("git", "diff", "--exit-code", "--quiet").Output()
		log.Println(string(out))
		if err != nil {
			log.Printf("skipped skipped updating /ops because the workspace is dirty")
			wallMessage("shqld/agent: skipped updating /ops because the workspace is dirty")
			return err
		}

		// FIXME: specify head sha
		log.Printf("running: 'git fetch origin main'\n")
		out, err = exec.Command("git", "fetch", "origin", "main").Output()
		log.Println(string(out))
		if err != nil {
			log.Printf("command failed: 'git fetch origin main' err=%s\n", err)
			return err
		}

		log.Printf("running: 'git reset --hard origin/main'\n")
		out, err = exec.Command("git", "reset", "--hard", "origin/main").Output()
		log.Println(string(out))
		if err != nil {
			log.Printf("command failed: 'git reset --hard origin/main' err=%s\n", err)
			return err
		}

		wallMessage("shqld/agent: updating /ops ...done")

		log.Printf("running: 'git gc --aggressive --prune=all'\n")
		out, err = exec.Command("git", "gc", "--aggressive", "--prune=all").Output()
		log.Println(string(out))
		if err != nil {
			log.Printf("command failed: 'git gc --aggressive --prune=all' err=%s\n", err)
			return err
		}

		log.Printf("running: 'du -sh /ops/.git'\n")
		out, err = exec.Command("du", "-sh", "/ops/.git").Output()
		log.Println(string(out))
		if err != nil {
			log.Printf("command failed: 'du -sh /ops/.git' err=%s\n", err)
			return err
		}

		log.Printf("running: 'make -C /ops setup'\n")
		out, err = exec.Command("make", "-C", "/ops", "setup").Output()
		log.Println(string(out))
		if err != nil {
			log.Printf("command failed: 'make -C /ops setup' err=%s\n", err)
			return err
		}
	}

	return nil
}

func handleWebhookGithubWorkflowRunEvent(w http.ResponseWriter, event *github.WorkflowRunEvent) error {
	workflow_run := event.GetWorkflowRun()

	if workflow_run.GetStatus() == "completed" {
		image_url := fmt.Sprintf("ghcr.io/%s/web:%s", workflow_run.GetRepository().GetFullName(), workflow_run.GetHeadSHA())

		full_name := workflow_run.GetRepository().GetFullName()
		name := workflow_run.GetRepository().GetName()

		switch full_name {
		case "shqld/varnish":
			return updateService(fmt.Sprintf("system_%s", name), image_url)
		case "shqld/dev":
		case "shqld/me":
			return updateService(fmt.Sprintf("app_%s", name), image_url)
		}
	}

	return nil
}

func updateService(service_name string, image_url string) error {
	wallMessage(fmt.Sprintf("shqld/agent: updating service %s to %s ...", service_name, image_url))

	log.Printf("running 'docker pull %s'\n", image_url)

	out, err := exec.Command("docker", "pull", image_url).Output()
	log.Println(string(out))
	if err != nil {
		log.Printf("command failed: 'docker pull %s' err=%s\n", image_url, err)
		return err
	}

	log.Printf("running 'docker service update %s --image %s'\n", service_name, image_url)

	out, err = exec.Command("docker", "service", "update", service_name, "--image", image_url).Output()
	log.Println(string(out))
	if err != nil {
		log.Printf("command failed: 'docker service update %s --image %s' err=%s\n", service_name, image_url, err)
		return err
	}

	wallMessage(fmt.Sprintf("shqld/agent: updating service %s to %s ...done", service_name, image_url))

	log.Printf("running 'docker system prune -f'\n")

	out, err = exec.Command("docker", "system", "prune", "-f").Output()
	log.Println(string(out))
	if err != nil {
		log.Printf("command failed: 'docker system prune -f' err=%s\n", err)
		return err
	}

	return nil
}

func wallMessage(message string) {
	exec.Command("wall", "-n", "'"+message+"'").Run()
}
