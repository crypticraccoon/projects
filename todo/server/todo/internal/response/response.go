package response

import (
	"encoding/json"
	"io"
	"net/http"
	"os"
	"server/internal/logging"
	"strconv"
)

func WithRedirect(w http.ResponseWriter, r *http.Request, redirectLink string) {
	http.Redirect(w, r, redirectLink, http.StatusFound)
}

func WithJson(w http.ResponseWriter, payload any) {

	//newPayload := map[string]any{
	//"success": payload,
	//}
	res, err := json.Marshal(payload)
	if err != nil {
		logging.Log.Error("Failed to marshal client response: " + err.Error())
		return
	}
	w.WriteHeader(http.StatusOK)
	if _, err := w.Write(res); err != nil {
		logging.Log.Error("Failed to send response to client: " + err.Error())
		return
	}
}

func WithError(w http.ResponseWriter, status int, payload string, err error) {
	logging.Log.Error(err.Error())
	//newPayload := map[string]any{
	//"error": payload,
	//}
	res, err := json.Marshal(payload)
	if err != nil {
		logging.Log.Error("Failed to marshal client response: " + err.Error())

	}
	w.WriteHeader(status)
	if _, err := w.Write(res); err != nil {
		logging.Log.Error("Failed to send error response to client: " + err.Error())
	}
}

func WithFile(w http.ResponseWriter, status int, fileType string, buf *[]byte) {
	w.Header().Add("Content-Type", fileType)
	w.WriteHeader(status)
	w.Write(*buf)
}

func StreamVideo(w http.ResponseWriter, r *http.Request, status int, fileType string, video *os.File) {
	fileInfo, err := video.Stat()
	if err != nil {
		logging.Log.Error("Failed to get file info: " + err.Error())
		return
	}

	buff, err := io.ReadAll(video)
	if err != nil {
		logging.Log.Error("Failed to read buffer: " + err.Error())
		return
	}

	defer video.Close()
	w.Header().Add("Content-Type", http.DetectContentType(buff))
	w.Header().Add("Content-Length", strconv.FormatInt(fileInfo.Size(), 10))
	w.Header().Add("Accept-Ranges", "bytes")
	w.WriteHeader(status)
	http.ServeContent(w, r, "fileName", fileInfo.ModTime(), video)
}

func WithStatus(w http.ResponseWriter, statusCode int) {
	w.WriteHeader(statusCode)
}
