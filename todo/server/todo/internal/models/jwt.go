package models

import (
	"os"
	"server/internal/errors"
	"strconv"
	"time"

	"github.com/gofrs/uuid"
	"github.com/golang-jwt/jwt/v5"
)

type Claims struct {
	UserID uuid.UUID `json:"user_id"`
	jwt.RegisteredClaims
}

type TokenPair struct {
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
}

type Jwt struct{}
type RefreshToken struct {
	RefreshToken string `json:"refresh_token"`
}

func (j *Jwt) GenerateAccessToken(userID uuid.UUID) (string, error) {
	tokenExp, err := strconv.Atoi(os.Getenv("ACCESS_TOKEN_EXPIRY"))
	if err != nil {
		return "", errors.ERR_MISSING_ENV
	}

	accessTokenExpiry := time.Second * time.Duration(tokenExp)

	claims := Claims{
		UserID: userID,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(accessTokenExpiry)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(os.Getenv("ACCESS_SECRET_KEY")))
}

func (j *Jwt) GenerateRefreshToken(userID uuid.UUID) (string, error) {
	tokenExp, err := strconv.Atoi(os.Getenv("REFRESH_TOKEN_EXPIRY"))
	if err != nil {
		return "", errors.ERR_MISSING_ENV
	}

	refreshTokenExpiry := time.Second * time.Duration(tokenExp)
	claims := Claims{
		UserID: userID,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(refreshTokenExpiry)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(os.Getenv("REFRESH_SECRET_KEY")))
}
