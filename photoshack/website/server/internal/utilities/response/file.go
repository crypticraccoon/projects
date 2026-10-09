package response

import "net/http"

func WithFile(w http.ResponseWriter, contentType string, payload []byte) {
	w.Header().Set("Content-Type", contentType)
	w.Write(payload)
}
