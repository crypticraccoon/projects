package response

import (
	"encoding/json"
	"log"
	"net/http"
	"ps_image/internal/errors"
)

func WithError(w http.ResponseWriter, statusCode int, error error) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)

	p := map[string]string{
		"error": error.Error(),
	}

	res, err := json.Marshal(p)
	if err != nil {
		bErr := map[string]string{
			"error": errors.ERR_UNABLE_TO_PARSE,
		}

		bErrConverted, bErrError := json.Marshal(bErr)
		if bErrError != nil {
			log.Println(errors.ERR_UNABLE_TO_PARSE)
		}
		w.Write(bErrConverted)
		return
	}

	w.Write([]byte(res))
}
