package main

import (
	"html/template"
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func Test_templateHandler(t *testing.T) {
	url := "XXXX_randomURL_XXXX"
	urls := []string{url}

	tests := []struct {
		name string
		tmpl string
		code int
	}{
		{name: "valid template", tmpl: "{{.}}", code: http.StatusOK},
		{name: "invalid template", tmpl: "{{.invalid}}", code: http.StatusInternalServerError},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tmpl := template.Must(template.New("test").Parse(tt.tmpl))
			ts := httptest.NewServer(&templateHandler{tmpl: tmpl, images: urls})
			defer ts.Close()

			resp, err := http.Get(ts.URL)
			require.NoError(t, err, "HTTP error")
			defer resp.Body.Close()

			require.Equal(t, tt.code, resp.StatusCode, "HTTP status code")
			if resp.StatusCode == http.StatusOK {
				body, err := ioutil.ReadAll(resp.Body)
				require.NoError(t, err, "failed to read HTTP body")
				assert.Contains(t, string(body), url)
			}
		})
	}
}
