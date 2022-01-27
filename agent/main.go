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
		handleWebhookGithubWorkflowRunEvent(w, event)
	}
}

func handleWebhookGithubWorkflowRunEvent(w http.ResponseWriter, event *github.WorkflowRunEvent) {
	workflow_run := event.GetWorkflowRun()

	if workflow_run.GetStatus() == "completed" {
		image_url := fmt.Sprintf("ghcr.io/%s/web:%s", workflow_run.GetRepository().GetFullName(), workflow_run.GetHeadSHA())

		if (workflow_run.GetRepository().GetFullName() == "shqld/me") {
			log.Printf("running 'docker pull %s'\n", image_url)

			out, err := exec.Command("docker", "pull", image_url).Output()
			if err != nil {
				log.Printf("command failed: 'docker pull %s' err=%s\n", image_url, err)
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			log.Println(string(out))

			log.Printf("running 'docker service update app_me --image %s'\n", image_url)

			out, err = exec.Command("docker", "service", "update", "app_me", "--image", image_url).Output()
			if err != nil {
				log.Printf("command failed: 'docker service update app_me --image %s' err=%s\n", image_url, err)
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			log.Println(string(out))

			log.Printf("running 'docker system prune -f'\n")

			out, err = exec.Command("docker", "system", "prune", "-f").Output()
			if err != nil {
				log.Printf("command failed: 'docker system prune -f' err=%s\n", err)
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			log.Println(string(out))
		}
	}
}
