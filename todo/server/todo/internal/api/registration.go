package api

import (
	"encoding/json"
	"errors"
	"net/http"
	"os"
	cerror "server/internal/errors"
	"server/internal/mailer"
	"server/internal/models"
	"server/internal/response"
	"strconv"

	"github.com/go-chi/chi/v5"
	"github.com/gofrs/uuid"
)

const (
	EMAIL_VERIFICATION_LINK_SENT = "An verification link was sent to your email."
	USER_INFORMATION_UPDATED     = "EMAIL_VERIFICATION_LINK_SENT"
)

func (a *Api) register(w http.ResponseWriter, r *http.Request) {
	println("asd")
	data := models.Register{}

	err := json.NewDecoder(r.Body).Decode(&data)

	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}

	isEmpty := data.IsEmpty()
	if isEmpty {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_PAYLOAD_EMPTY.Error(), cerror.ERR_PAYLOAD_EMPTY)
		return
	}

	if isValidEmail := data.IsValidEmail(); !isValidEmail {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_EMAIL.Error(), cerror.ERR_API_MALFORMED_EMAIL)
		return
	}

	newUser, err := models.NewUser(a.context, data.Email, data.Password)
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_FAILED_TO_CREATE_USER.Error(), err)
		return
	}

	if err = a.database.RegisterUser(a.context, newUser); err != nil {
		if errors.Is(err, cerror.ERR_DB_USER_EXISTS) {
			response.WithError(w, http.StatusConflict, err.Error(), err)
			return
		} else {
			response.WithError(w, http.StatusInternalServerError, cerror.ERR_DB_TX_FAILED.Error(), err)
			return
		}
	}

	serverUrl := os.Getenv("SERVER_URL")
	redirectLink := serverUrl + "/register/verify/" + newUser.Id.String() + "/" + strconv.FormatInt(int64(newUser.VerificationCode), 10)

	if mailer.Mail.IsEnabled() {
		if err = mailer.Mail.SendEmailVerificationLink(a.context, redirectLink, newUser.Email); err != nil {
			if err := a.database.DeleteUser(a.context, newUser.Id); err != nil {
				response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_FAILED_TO_CREATE_USER.Error(), err)
				return
			}
		}
	} else {
		redirectLink := serverUrl + "/register/verify/" + newUser.Id.String() + "/" + strconv.FormatInt(int64(newUser.VerificationCode), 10)
		println("Run the following to verify user registration.")
		println(`curl --request GET --url ` + redirectLink + ` --header 'Content-Type: application/json' `)
	}

	response.WithJson(w, EMAIL_VERIFICATION_LINK_SENT)
}

func (a *Api) verifyRegistrationEmail(w http.ResponseWriter, r *http.Request) {
	verificationCode, err := strconv.Atoi(chi.URLParam(r, "code"))
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}
	id := uuid.FromStringOrNil(chi.URLParam(r, "id"))
	if id == uuid.Nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), cerror.ERR_API_MALFORMED_DATA)
		return
	}

	isRegistered, err := a.database.IsUserRegistered(a.context, id)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_VERIFICATION_FAILED.Error(), err)
		return
	}
	if isRegistered {
		registrationVerificationLink := os.Getenv("ROOT_REDIRECT")
		response.WithRedirect(w, r, registrationVerificationLink)
		return
	}

	exists, err := a.database.VerifyUserEmail(a.context, id, verificationCode)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_VERIFICATION_FAILED.Error(), err)
		return
	}

	if !exists {
		response.WithError(w, http.StatusNotFound, cerror.ERR_DB_USER_MISSING.Error(), cerror.ERR_DB_USER_MISSING)
		return
	}

	registrationVerificationLink := os.Getenv("ROOT_REDIRECT") + "/register/setup/" + id.String() + "/" + strconv.FormatInt(int64(verificationCode), 10)

	response.WithRedirect(w, r, registrationVerificationLink)
}

func (a *Api) addUserData(w http.ResponseWriter, r *http.Request) {

	verificationCode, err := strconv.Atoi(chi.URLParam(r, "code"))
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}
	id := uuid.FromStringOrNil(chi.URLParam(r, "id"))
	if id == uuid.Nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), cerror.ERR_API_MALFORMED_DATA)
		return
	}

	exists, err := a.database.CheckIfUserExist(a.context, id, verificationCode)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_FAILED_UPDATE_USER.Error(), err)
		return
	}

	if !exists {
		response.WithError(w, http.StatusNotFound, cerror.ERR_DB_USER_MISSING.Error(), cerror.ERR_DB_USER_MISSING)
		return
	}

	data := models.UserAdditionalData{}
	err = json.NewDecoder(r.Body).Decode(&data)

	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}

	if isValid := data.IsValid(); !isValid {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), cerror.ERR_API_MALFORMED_DATA)
		return
	}

	if err = a.database.UpdateUserAdditionalData(a.context, &data, id); err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_FAILED_UPDATE_USER.Error(), err)
		return
	}

	response.WithJson(w, USER_INFORMATION_UPDATED)
}
