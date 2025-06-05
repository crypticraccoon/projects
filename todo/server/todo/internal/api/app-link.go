package api

import (
	"net/http"
	"os"
	cerror "server/internal/errors"
	"server/internal/response"
)

// Server links back to application name
func (a *Api) serveAssetLinks(w http.ResponseWriter, r *http.Request) {

	buf, err := os.ReadFile("./.well-known/assetlinks.json")
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_STORAGE_FILE_MISSING.Error(), err)
		return
	}

	response.WithFile(w, http.StatusOK, "application/json", &buf)
}
