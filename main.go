package main

import (
	"html/template"
	"log"
	"math/rand"
	"net/http"
	"path/filepath"
	"sync"
)

type templateHandler struct {
	tmpl *template.Template
	mu   sync.RWMutex

	// protected by mu
	images []string
}

func (t *templateHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	t.mu.RLock()
	url := t.images[rand.Intn(len(t.images))]
	t.mu.RUnlock()

	if err := t.tmpl.Execute(w, url); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func main() {

	images := []string{
		"https://img.buzzfeed.com/buzzfeed-static/static/2019-04/10/15/asset/buzzfeed-prod-web-06/sub-buzz-27740-1554926029-1.jpg?downsize=700%3A%2A&output-quality=auto&output-format=auto",
		"https://img.buzzfeed.com/buzzfeed-static/static/2019-04/10/16/asset/buzzfeed-prod-web-02/sub-buzz-3095-1554928262-1.jpg?downsize=700%3A%2A&output-quality=auto&output-format=auto",
		"https://img.buzzfeed.com/buzzfeed-static/static/2019-04/10/16/asset/buzzfeed-prod-web-03/sub-buzz-9867-1554929262-1.jpg?downsize=700%3A%2A&output-quality=auto&output-format=auto",
		"https://img.buzzfeed.com/buzzfeed-static/static/2019-04/10/16/asset/buzzfeed-prod-web-05/sub-buzz-26839-1554929491-1.jpg?downsize=600:*&output-format=auto&output-quality=auto",
		"https://img.buzzfeed.com/buzzfeed-static/static/2019-04/10/16/asset/buzzfeed-prod-web-01/sub-buzz-8758-1554926462-1.jpg?downsize=600:*&output-format=auto&output-quality=auto",
		"https://img.buzzfeed.com/buzzfeed-static/static/2019-04/10/16/asset/buzzfeed-prod-web-01/sub-buzz-8758-1554926462-1.jpg?downsize=600:*&output-format=auto&output-quality=auto",
		"https://img.buzzfeed.com/buzzfeed-static/static/2019-04/10/16/asset/buzzfeed-prod-web-04/sub-buzz-19835-1554927404-1.jpg?downsize=600:*&output-format=auto&output-quality=auto",
	}

	tmpl := template.Must(template.ParseFiles(filepath.Join("templates", "index.html")))
	log.Fatal(http.ListenAndServe(":80", &templateHandler{tmpl: tmpl, images: images}))
}
