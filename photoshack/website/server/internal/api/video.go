package api

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"os/exec"
	cErrors "ps_image/internal/errors"
	"ps_image/internal/misc"
	"ps_image/internal/model"

	"ps_image/internal/utilities/response"
	"strconv"

	"github.com/go-chi/chi/v5"
)

func GetVideoThumbnailNames(w http.ResponseWriter, r *http.Request) {
	year := chi.URLParam(r, "year")
	month := chi.URLParam(r, "month")
	day := chi.URLParam(r, "day")
	period := chi.URLParam(r, "period")

	fileData, err := os.ReadDir(os.Getenv("PSDIR") + "/" + year + "/" + month + "/" + day + "/" + period + "/videos/thumbnails/")
	if err != nil {
		response.WithError(w, http.StatusNotFound, errors.New(cErrors.ERR_MISSING_FOLDER))
		return
	}

	var fileNames []string
	for i := range fileData {
		fileNames = append(fileNames, fileData[i].Name())
	}

	response.WithJson(w, http.StatusOK, fileNames)
	return
}

func GetVideoThumbnail(w http.ResponseWriter, r *http.Request) {
	year := chi.URLParam(r, "year")
	month := chi.URLParam(r, "month")
	day := chi.URLParam(r, "day")
	period := chi.URLParam(r, "period")
	fileName := chi.URLParam(r, "fileName")

	filePath := os.Getenv("PSDIR") + "/" + year + "/" + month + "/" + day + "/" + period + "/videos/thumbnails/" + fileName
	imgBuffer, err := os.ReadFile(filePath)

	if err != nil {
		response.WithError(w, http.StatusNotFound, errors.New(cErrors.ERR_INVALID_PATH))
		return
	}
	response.WithFile(w, "image/jpg", imgBuffer)
	return
}

func ExtractVideos(w http.ResponseWriter, r *http.Request) {

	data := &model.VideoScriptModel{}
	buffer, err := io.ReadAll(r.Body)
	if err != nil {
		response.WithError(w, http.StatusBadRequest, errors.New(cErrors.ERR_INVALID_DATA))
		return
	}

	err = json.Unmarshal(buffer, data)
	if err != nil {
		response.WithError(w, http.StatusBadRequest, errors.New(cErrors.ERR_INVALID_DATA))
		return
	}
	cmdStruct := exec.Command(
		"/bin/bash",
		[]string{
			os.Getenv("VIDEOEXTRACTSCRIPT"),
			data.TargetPath,
			data.DestinationPath,
			data.WatermarkPath,
			data.TimePeriod,
			strconv.FormatBool(data.UploadToServer),
			data.ServerPath,
			data.Alpha,
			strconv.FormatBool(data.Append),
		}...,
	)

	scriptRes, err := cmdStruct.Output()
	if err != nil {
		fmt.Println(string(scriptRes))
		fmt.Println(err)
		if string(scriptRes) == cErrors.ERR_SCRIPT_MISSING_TARGET {
			response.WithError(w, http.StatusNotFound, errors.New(cErrors.RES_SCRIPT_MISSING_TARGET))
			return
		} else if string(scriptRes) == cErrors.ERR_SCRIPT_MISSING_DESTINATION {
			response.WithError(w, http.StatusNotFound, errors.New(cErrors.RES_SCRIPT_MISSING_DESTINATION))
			return
		} else if string(scriptRes) == cErrors.ERR_SCRIPT_INVALID_PERIOD {
			response.WithError(w, http.StatusBadRequest, errors.New(cErrors.RES_SCRIPT_INVALID_PERIOD))
			return
		} else if string(scriptRes) == cErrors.ERR_SCRIPT_INVALID_ARG {
			response.WithError(w, http.StatusBadRequest, errors.New(cErrors.RES_SCRIPT_INVALID_ARG))
			return
		} else if string(scriptRes) == cErrors.ERR_SCRIPT_TARGET_PERIOD_TAKEN {
			response.WithError(w, http.StatusConflict, errors.New(cErrors.RES_SCRIPT_TARGET_PERIOD_TAKEN))
			return
		} else if string(scriptRes) == cErrors.ERR_SCRIPT_DESTINATION_PERIOD_TAKEN {
			response.WithError(w, http.StatusConflict, errors.New(cErrors.RES_SCRIPT_DESTINATION_PERIOD_TAKEN))
			return
		} else if string(scriptRes) == cErrors.ERR_SCRIPT_MULTIPLE_TARGETS_FOUND {
			response.WithError(w, http.StatusConflict, errors.New(cErrors.RES_SCRIPT_MULTIPLE_TARGETS_FOUND))
			return
		}
		response.WithError(w, http.StatusInternalServerError, errors.New(cErrors.ERR_SCRIPT_VIDEO_EXTRACTION_FAILED))
		return
	}

	response.WithJson(w, http.StatusOK, misc.RESP_VIDEOS_EXTRACTED)
	return
}

func StreamVideo(w http.ResponseWriter, r *http.Request) {
	year := chi.URLParam(r, "year")
	month := chi.URLParam(r, "month")
	day := chi.URLParam(r, "day")
	period := chi.URLParam(r, "period")
	fileName := chi.URLParam(r, "fileName")

	filePath := os.Getenv("PSDIR") + "/" + year + "/" + month + "/" + day + "/" + period + "/videos/compressed/" + fileName
	println(filePath)
	w.Header().Set("Content-Type", "video/*")
	w.Header().Set("Accept-Ranges", "bytes")
	http.ServeFile(w, r, filePath)
	return
}
