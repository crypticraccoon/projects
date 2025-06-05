package api

import (
	"encoding/json"
	"net/http"
	"os"
	cerror "server/internal/errors"
	"server/internal/models"
	"server/internal/response"

	"github.com/gofrs/uuid"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
)

func (a *Api) login(w http.ResponseWriter, r *http.Request) {
	data := models.Login{}
	if err := json.NewDecoder(r.Body).Decode(&data); err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}

	if valid := data.Check(); !valid {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), cerror.ERR_API_MALFORMED_DATA)
		return

	}

	userData, err := a.database.GetUserByCredentials(a.context, &data)
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_INVALID_CREDENTIALS.Error(), err)
		return
	}

	if bcrypt.CompareHashAndPassword([]byte(userData.Password), []byte(data.Password)) != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_INVALID_CREDENTIALS.Error(), cerror.ERR_API_INVALID_CREDENTIALS)
		return
	}

	if !userData.IsVerified {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_USER_NOT_VERIFIED.Error(), cerror.ERR_API_USER_NOT_VERIFIED)
		return
	}

	jwtH := models.Jwt{}

	accessToken, err := jwtH.GenerateAccessToken(userData.Id)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_LOGIN_FAILED.Error(), err)
		return
	}

	refreshToken, err := jwtH.GenerateRefreshToken(userData.Id)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_LOGIN_FAILED.Error(), err)
		return
	}

	if err = a.database.UpdateRefreshToken(a.context, userData.Id, refreshToken); err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_LOGIN_FAILED.Error(), err)
		return
	}

	res := models.LoginResponse{
		Id: userData.Id,
		TokenData: models.TokenPair{
			AccessToken:  accessToken,
			RefreshToken: refreshToken,
		},
	}

	response.WithJson(w, res)
}

func (a *Api) logout(w http.ResponseWriter, r *http.Request) {
	id := r.Context().Value("userID")
	if id == nil {
		response.WithError(w, http.StatusForbidden, cerror.ERR_API_LOGOUT_FAILED.Error(), cerror.ERR_API_LOGOUT_FAILED)
		return

	}
	userId := uuid.FromStringOrNil(r.Context().Value("userID").(string))

	if err := a.database.RemoveRefreshToken(a.context, userId); err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_LOGOUT_FAILED.Error(), err)
		return
	}

	response.WithJson(w, "User successfully logged out.")
}

func (a *Api) refresh(w http.ResponseWriter, r *http.Request) {
	refreshSecretKey := []byte(os.Getenv("REFRESH_SECRET_KEY"))
	jwtH := models.Jwt{}

	data := models.RefreshToken{}
	if err := json.NewDecoder(r.Body).Decode(&data); err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}

	token, err := jwt.ParseWithClaims(data.RefreshToken, &models.Claims{}, func(token *jwt.Token) (any, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, cerror.ERR_API_INVALID_TOKEN
		}
		return refreshSecretKey, nil
	})

	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_INVALID_TOKEN.Error(), err)
		return
	}

	claims, ok := token.Claims.(*models.Claims)
	if !ok || !token.Valid {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_INVALID_TOKEN.Error(), err)
		return
	}

	refreshToken, err := a.database.GetRefreshToken(a.context, claims.UserID)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_TOKEN_REFRESH_FAILED.Error(), err)
		return
	}
	if refreshToken != data.RefreshToken {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_INVALID_TOKEN.Error(), err)
		return
	}

	newAccessToken, err := jwtH.GenerateAccessToken(claims.UserID)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_TOKEN_REFRESH_FAILED.Error(), err)
		return
	}

	newRefreshToken, err := jwtH.GenerateRefreshToken(claims.UserID)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_TOKEN_REFRESH_FAILED.Error(), err)
		return
	}
	if err = a.database.UpdateRefreshToken(a.context, claims.UserID, newRefreshToken); err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_LOGIN_FAILED.Error(), err)
		return
	}

	res := models.TokenPair{
		AccessToken:  newAccessToken,
		RefreshToken: newRefreshToken,
	}
	response.WithJson(w, res)
}
