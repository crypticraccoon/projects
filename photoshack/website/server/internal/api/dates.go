package api

import (
	"errors"
	"net/http"
	"os"
	"os/exec"
	cErrors "ps_image/internal/errors"
	"ps_image/internal/misc"
	"ps_image/internal/model"
	"ps_image/internal/utilities"
	"ps_image/internal/utilities/response"
)

func GetDates(w http.ResponseWriter, r *http.Request) {
	dates := []model.Date{}
	cmdStruct := exec.Command("find", "/photos", "-name", misc.DIRTYFILE, "-delete")
	_, err := cmdStruct.Output()
	if err != nil {
	}
	yearFolder, err := os.ReadDir(os.Getenv("PSDIR"))
	if err != nil {
		response.WithError(w, http.StatusNotFound, errors.New(cErrors.ERR_MISSING_FOLDER))
		return
	}

	yearFolder = utilities.RemoveDSStore(yearFolder)
	for yIndex, year := range yearFolder {
		dates = append(dates, model.Date{Year: year.Name(), Month: []model.Month{}})

		monthFolderPath := os.Getenv("PSDIR") + "/" + year.Name()
		monthFolder, err := os.ReadDir(monthFolderPath)
		if err != nil {

			response.WithError(w, http.StatusNotFound, errors.New(cErrors.ERR_MISSING_FOLDER))
			return
		}
		monthFolder = utilities.RemoveDSStore(monthFolder)
		for mIndex, month := range monthFolder {
			mHolder := model.Month{Month: month.Name(), Day: []model.Day{}}
			dates[yIndex].Month = append(dates[yIndex].Month, mHolder)

			dayFolderPath := os.Getenv("PSDIR") + "/" + year.Name() + "/" + month.Name()
			dayFolder, err := os.ReadDir(dayFolderPath)
			if err != nil {

				response.WithError(w, http.StatusNotFound, errors.New(cErrors.ERR_MISSING_FOLDER))
				return
			}
			dayFolder = utilities.RemoveDSStore(dayFolder)
			for dIndex, day := range dayFolder {
				dHolder := model.Day{Day: day.Name(), Period: []model.Period{}}
				dates[yIndex].Month[mIndex].Day = append(dates[yIndex].Month[mIndex].Day, dHolder)

				periodFolderPath := os.Getenv("PSDIR") + "/" + year.Name() + "/" + month.Name() + "/" + day.Name()
				periodFolder, err := os.ReadDir(periodFolderPath)
				if err != nil {

					response.WithError(w, http.StatusNotFound, errors.New(cErrors.ERR_MISSING_FOLDER))
					return
				}

				periodFolder = utilities.RemoveDSStore(periodFolder)
				for pIndex, period := range periodFolder {
					pHolder := model.Period{Period: period.Name(), Position: []model.Position{}}
					dates[yIndex].Month[mIndex].Day[dIndex].Period = append(dates[yIndex].Month[mIndex].Day[dIndex].Period, pHolder)

					positionFolderPath := os.Getenv("PSDIR") + "/" + year.Name() + "/" + month.Name() + "/" + day.Name() + "/" + period.Name()
					positionFolder, err := os.ReadDir(positionFolderPath)
					if err != nil {

						response.WithError(w, http.StatusNotFound, errors.New(cErrors.ERR_MISSING_FOLDER))
						return
					}

					positionFolder = utilities.RemoveDSStore(positionFolder)

					for posIndex, position := range positionFolder {
						if position.Name() != "videos" {
							posHolder := model.Position{Position: position.Name(), Files: []string{}}
							dates[yIndex].Month[mIndex].Day[dIndex].Period[pIndex].Position = append(
								dates[yIndex].Month[mIndex].Day[dIndex].Period[pIndex].Position,
								posHolder,
							)

							filesFolderPath := os.Getenv("PSDIR") + "/" + year.Name() + "/" + month.Name() + "/" + day.Name() + "/" + period.Name() + "/" + position.Name() + "/compressed"

							filesFolder, err := os.ReadDir(filesFolderPath)
							if err != nil {
								response.WithError(w, http.StatusNotFound, errors.New(cErrors.ERR_MISSING_FOLDER))
								return
							}

							for _, files := range filesFolder {
								dates[yIndex].Month[mIndex].Day[dIndex].Period[pIndex].Position[posIndex].Files = append(
									dates[yIndex].Month[mIndex].Day[dIndex].Period[pIndex].Position[posIndex].Files,
									files.Name(),
								)
							}
						}
					}
				}
			}
		}
	}
	response.WithJson(w, http.StatusOK, dates)
	return
}
