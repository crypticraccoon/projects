package response

import (
	"encoding/json"
	"log"
	"net/http"
	"ps_image/internal/errors"
)

func WithJson(w http.ResponseWriter, statusCode int, payload interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)

	if payload == nil {
		log.Fatal(errors.ERR_EMPTY_PAYLOAD)
	}

	newPayload := map[string]interface{}{
		"success": payload,
	}

	data, err := json.Marshal(newPayload)
	if err != nil {
		WithError(w, http.StatusInternalServerError, err)
		return
	}

	if string(data) == "null" {
		_, _ = w.Write([]byte("[]"))
		return
	}

	_, err = w.Write(data)
	if err != nil {
		log.Println(err)
		WithError(w, http.StatusInternalServerError, err)
		return
	}

}
