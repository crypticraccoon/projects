package api

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/exec"
	"strconv"

	cErrors "ps_image/internal/errors"
	"ps_image/internal/misc"
	"ps_image/internal/model"
	"ps_image/internal/utilities/response"
)

func GetBorderCount(w http.ResponseWriter, r *http.Request) {
	data := &model.ImageCountModel{}
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
			os.Getenv("IMAGECOUNRTSCRIPT"),
			data.Delimiter,
			data.TargetPath,
			data.TimePeriod,
			strconv.FormatBool(data.JoinFolders),
			data.DestinationPath,
		}...,
	)
	scriptRes, err := cmdStruct.Output()
	if err != nil {
		fmt.Println(string(scriptRes))
		fmt.Println(err)
		if string(scriptRes) == cErrors.ERR_SCRIPT_MISSING_TARGET {
			response.WithError(w, http.StatusBadRequest, errors.New(cErrors.RES_SCRIPT_MISSING_TARGET))
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
		response.WithError(w, http.StatusInternalServerError, errors.New(string(scriptRes)))
		return
	}

	response.WithJson(w, http.StatusOK, string(scriptRes))
	return
}

func ExtractPhotos(w http.ResponseWriter, r *http.Request) {

	data := &model.ExtractImageModel{}
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
			os.Getenv("IMAGEEXTRACTSCRIPT"),
			data.TimePeriod,
			data.Delimiter,
			data.TargetPath,
			data.ServerPath,
			data.DestinationPath,
			data.WatermarkPath,
			strconv.FormatBool(data.UploadToServer),
			data.Alpha,
		}...,
	)

	scriptRes, err := cmdStruct.Output()

	fmt.Println(string(scriptRes))
	fmt.Println(err)

	if err != nil {
		if string(scriptRes) == cErrors.ERR_SCRIPT_DESTINATION_PERIOD_TAKEN {
			response.WithError(w, http.StatusConflict, errors.New(cErrors.RES_SCRIPT_DESTINATION_PERIOD_TAKEN))
			return
		} else if string(scriptRes) == cErrors.ERR_SCRIPT_TARGET_PERIOD_TAKEN {
			response.WithError(w, http.StatusConflict, errors.New(cErrors.RES_SCRIPT_TARGET_PERIOD_TAKEN))
			return
		} else if string(scriptRes) == cErrors.ERR_SCRIPT_INVALID_PERIOD {
			response.WithError(w, http.StatusBadRequest, errors.New(cErrors.RES_SCRIPT_INVALID_PERIOD))
			return
		} else if string(scriptRes) == cErrors.ERR_SCRIPT_MISSING_TARGET {
			response.WithError(w, http.StatusNotFound, errors.New(cErrors.RES_SCRIPT_MISSING_TARGET))
			return
		} else if string(scriptRes) == cErrors.ERR_SCRIPT_MULTIPLE_TARGETS_FOUND {
			response.WithError(w, http.StatusNotFound, errors.New(cErrors.RES_SCRIPT_MULTIPLE_TARGETS_FOUND))
			return
		}

		response.WithError(w, http.StatusInternalServerError, errors.New(cErrors.ERR_SCRIPT_IMAGE_EXTRACTION_FAILED))
		return
	}

	response.WithJson(w, http.StatusOK, misc.RES_PHOTOS_EXTRACTED)
	return
}

func GetThumbnail(w http.ResponseWriter, r *http.Request) {
	tnData := model.ThumbnailModel{}
	data := json.NewDecoder(r.Body)
	err := data.Decode(&tnData)
	if err != nil {
		response.WithError(w, http.StatusBadRequest, errors.New(cErrors.ERR_INVALID_DATA))
		return
	}
	filePath := os.Getenv("PSDIR") + "/" + tnData.Year + "/" + tnData.Month + "/" + tnData.Day + "/" + tnData.Period + "/" + tnData.Position + "/thumbnails/thumbnail.jpg"
	imgBuffer, err := os.ReadFile(filePath)

	if err != nil {
		response.WithError(w, http.StatusNotFound, errors.New(cErrors.ERR_INVALID_PATH))
		return
	}

	response.WithFile(w, "image/jpg", imgBuffer)
	return

}

func GetImage(w http.ResponseWriter, r *http.Request) {
	imageData := model.Image{}
	data := json.NewDecoder(r.Body)
	err := data.Decode(&imageData)
	if err != nil {
		log.Println(err)
		response.WithError(w, http.StatusBadRequest, errors.New(cErrors.ERR_INVALID_DATA))
		return
	}

	filePath := os.Getenv("PSDIR") + "/" + imageData.Year + "/" + imageData.Month + "/" + imageData.Day + "/" + imageData.Period + "/" + imageData.Position + "/" + "compressed" + "/" + imageData.FileName
	imgBuffer, err := os.ReadFile(filePath)

	if err != nil {
		response.WithError(w, http.StatusNotFound, errors.New(cErrors.ERR_INVALID_PATH))
		return
	}
	response.WithFile(w, "image/jpg", imgBuffer)
	return
}
