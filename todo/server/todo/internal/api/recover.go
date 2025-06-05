package api

import (
	"encoding/base64"
	"encoding/json"
	"net/http"
	"os"
	cerror "server/internal/errors"
	"server/internal/mailer"
	"server/internal/models"
	"server/internal/response"
	"server/internal/utils"
	"strconv"

	"github.com/go-chi/chi/v5"
)

const (
	RECOVERY_LINK_SENT = "An recovery link was sent to your email."
)

func (a *Api) sendRecoveryEmail(w http.ResponseWriter, r *http.Request) {
	data := models.Recovery{}

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
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_FAILED_TO_SEND_RECOVERY_EMAIL.Error(), err)
		return
	}

	if !isTaken {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_EMAIL_NOT_FOUND.Error(), cerror.ERR_API_EMAIL_NOT_FOUND)
		return

	}

	recoveryCode := utils.CreateCode()
	if err = a.database.SetRecoveryCode(a.context, data.Email, recoveryCode); err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_FAILED_TO_SEND_RECOVERY_EMAIL.Error(), err)
		return
	}

	emailBase64 := base64.URLEncoding.EncodeToString([]byte(data.Email))

	serverUrl := os.Getenv("SERVER_URL")
	redirectLink := serverUrl + "/recover/verify/" + emailBase64 + "/" + strconv.FormatInt(int64(recoveryCode), 10)
	if mailer.Mail.IsEnabled() {
		if err = mailer.Mail.SendEmailRecoveryLink(a.context, redirectLink, data.Email); err != nil {
			response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_FAILED_TO_SEND_RECOVERY_EMAIL.Error(), err)
			return
		}
	} else {

		redirectLink := "http://localhost:3000/v1/recover/update/" + emailBase64 + "/" + strconv.FormatInt(int64(recoveryCode), 10)

		println("Run the following to verify user recovery link.")
		println(`curl --request GET --url ` + redirectLink + ` --header 'Content-Type: application/json' `)
	}

	if err = a.database.ToggleRecoveryMode(a.context, data.Email, true); err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_FAILED_TO_SEND_RECOVERY_EMAIL.Error(), err)
		return
	}

	response.WithJson(w, RECOVERY_LINK_SENT)
}

func (a *Api) verifyRecoveryEmail(w http.ResponseWriter, r *http.Request) {
	verificationCode, err := strconv.Atoi(chi.URLParam(r, "code"))
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}
	email, err := base64.URLEncoding.DecodeString(chi.URLParam(r, "email"))
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}

	isRecoveryMode, err := a.database.GetRecoveryStatus(a.context, string(email), verificationCode)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_VERIFICATION_FAILED.Error(), err)
		return
	}

	if !isRecoveryMode {
		registrationVerificationLink := os.Getenv("ROOT_REDIRECT")
		response.WithRedirect(w, r, registrationVerificationLink)
		return

	}

	exists, err := a.database.VerifyRecoveryEmail(a.context, string(email), verificationCode)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_VERIFICATION_FAILED.Error(), err)
		return
	}

	if !exists {
		response.WithError(w, http.StatusNotFound, cerror.ERR_DB_USER_MISSING.Error(), cerror.ERR_DB_USER_MISSING)
		return
	}

	registrationVerificationLink := os.Getenv("ROOT_REDIRECT") + "/recover/update/" + chi.URLParam(r, "email") + "/" + strconv.FormatInt(int64(verificationCode), 10)

	response.WithRedirect(w, r, registrationVerificationLink)
}

func (a *Api) updateRecoverPassowrd(w http.ResponseWriter, r *http.Request) {

	verificationCode, err := strconv.Atoi(chi.URLParam(r, "code"))
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}
	email, err := base64.URLEncoding.DecodeString(chi.URLParam(r, "email"))
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}

	exists, err := a.database.VerifyRecoveryEmail(a.context, string(email), verificationCode)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_FAILED_TO_UPDATE_PASSWORD.Error(), err)
		return
	}

	if !exists {
		response.WithError(w, http.StatusNotFound, cerror.ERR_DB_USER_MISSING.Error(), cerror.ERR_DB_USER_MISSING)
		return
	}

	user := models.User{}

	data := models.RecoveryPassword{}
	err = json.NewDecoder(r.Body).Decode(&data)
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}

	isValid := data.IsValid()
	if !isValid {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), cerror.ERR_API_MALFORMED_DATA)
		return
	}

	newPasswordHash, err := user.GenerateNewPassword(data.Password)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_FAILED_TO_UPDATE_PASSWORD.Error(), err)
		return
	}

	if err = a.database.UpdateRecoveryPassword(a.context, string(email), string(newPasswordHash)); err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_DB_UPDATE_FAILED.Error(), err)
		return
	}

	if err = a.database.ToggleRecoveryMode(a.context, string(email), false); err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_FAILED_TO_SEND_RECOVERY_EMAIL.Error(), err)
		return
	}

	response.WithJson(w, USER_UPDATED)
}
