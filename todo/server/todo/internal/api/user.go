package api

import (
	"encoding/json"
	"errors"
	"github.com/gofrs/uuid"
	"github.com/jackc/pgx/v5"
	"net/http"
	cerror "server/internal/errors"
	"server/internal/models"
	"server/internal/response"
)

const (
	USER_UPDATED = "Updated."
)

func (a *Api) getUserData(w http.ResponseWriter, r *http.Request) {
	id := uuid.FromStringOrNil(r.Context().Value("userID").(string))

	data, err := a.database.GetUser(a.context, id)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			response.WithError(w, http.StatusNotFound, cerror.ERR_DB_USER_MISSING.Error(), err)
			return
		} else {
			response.WithError(w, http.StatusInternalServerError, cerror.ERR_DB_QUERY_FAILED.Error(), err)
			return
		}
	}

	strippedUser := data.StripUser(data)

	response.WithJson(w, strippedUser)
}

func (a *Api) updateUsername(w http.ResponseWriter, r *http.Request) {
	id := uuid.FromStringOrNil(r.Context().Value("userID").(string))

	data := models.Username{}
	err := json.NewDecoder(r.Body).Decode(&data)

	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}

	if err = a.database.UpdateUsername(a.context, id, data.Username); err != nil {

		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_FAILED_UPDATE_USERNAME.Error(), err)
		return
	}

	response.WithJson(w, USER_UPDATED)
}

func (a *Api) updatePassword(w http.ResponseWriter, r *http.Request) {

	id := uuid.FromStringOrNil(r.Context().Value("userID").(string))

	user := models.User{}

	data := models.Password{}
	err := json.NewDecoder(r.Body).Decode(&data)
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}

	isValid := data.IsValid()
	if !isValid {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), cerror.ERR_API_MALFORMED_DATA)
		return
	}

	pwdHash, err := a.database.GetPasswordHash(a.context, id)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_DB_QUERY_FAILED.Error(), err)
		return
	}

	if err := user.CheckPassword(pwdHash, data.Password); err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_FAILED_TO_UPDATE_PASSWORD.Error(), err)
		return
	}

	newPasswordHash, err := user.GenerateNewPassword(data.NewPassword)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_FAILED_TO_UPDATE_PASSWORD.Error(), err)
		return
	}

	if err = a.database.UpdatePassword(a.context, id, string(newPasswordHash)); err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_DB_QUERY_FAILED.Error(), err)
		return
	}

	response.WithJson(w, USER_UPDATED)
}

func (a *Api) updateEmail(w http.ResponseWriter, r *http.Request) {
	id := uuid.FromStringOrNil(r.Context().Value("userID").(string))

	data := models.Email{}
	err := json.NewDecoder(r.Body).Decode(&data)

	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}

	if isValidEmail := data.IsValidEmail(); !isValidEmail {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_EMAIL.Error(), cerror.ERR_API_MALFORMED_EMAIL)
		return
	}

	isTaken, err := a.database.IsEmailTaken(a.context, data.Email)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_FAILED_TO_UPDATE_EMAIL.Error(), err)
		return
	}
	if isTaken {
		response.WithError(w, http.StatusConflict, cerror.ERR_DB_EMAIL_TAKEN.Error(), cerror.ERR_DB_EMAIL_TAKEN)
		return
	}

	if err = a.database.UpdateEmail(a.context, id, data.Email); err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_FAILED_TO_UPDATE_EMAIL.Error(), err)
		return
	}

	response.WithJson(w, USER_UPDATED)
}
