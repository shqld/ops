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

	fmt.Println("server listening at 8000")

	log.Fatal(http.ListenAndServe(":8000", nil))
}

func handleWebhookGithub(w http.ResponseWriter, req *http.Request) {
	fmt.Println(req.Method, req.URL)

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

	fmt.Println("webhook_type", webhook_type)

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

		fmt.Println("image_url", image_url)
		io.WriteString(w, image_url)

		out, err := exec.Command("docker", "pull", image_url).Output()
		if err != nil {
			log.Printf("command failed: 'docker pull %s' err=%s\n", image_url, err)
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		w.Write(out)
		fmt.Println(string(out))

		out, err = exec.Command("docker-compose", "-f", "/ops/app/docker-compose.yaml", "up", "-d").Output()
		if err != nil {
			log.Printf("command failed: 'docker-compose -f /ops/app/docker-compose.yaml up -d' err=%s\n", err)
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		w.Write(out)
		fmt.Println(string(out))
	}
}
