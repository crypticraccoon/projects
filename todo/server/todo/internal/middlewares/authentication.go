package middlewares

import (
	"context"
	"net/http"
	"os"
	cerror "server/internal/errors"
	"server/internal/models"
	"server/internal/response"
	"strings"

	"github.com/golang-jwt/jwt/v5"
)

func AuthMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		secretKey := []byte(os.Getenv("ACCESS_SECRET_KEY"))
		authHeader := r.Header.Get("Authorization")
		if authHeader == "" {
			response.WithError(w, http.StatusUnauthorized, cerror.ERR_API_INVALID_TOKEN.Error(), cerror.ERR_API_INVALID_TOKEN)
			return
		}

		tokenString := strings.Replace(authHeader, "Bearer ", "", 1)

		token, err := jwt.ParseWithClaims(tokenString, &models.Claims{}, func(token *jwt.Token) (any, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, cerror.ERR_API_INVALID_TOKEN
			}
			return secretKey, nil
		})

		if err != nil {
			response.WithError(w, http.StatusUnauthorized, cerror.ERR_API_INVALID_TOKEN.Error(), err)
			return
		}

		if claims, ok := token.Claims.(*models.Claims); ok && token.Valid {
			ctx := context.WithValue(r.Context(), "userID", claims.UserID.String())
			next.ServeHTTP(w, r.WithContext(ctx))
		} else {
			response.WithError(w, http.StatusUnauthorized, cerror.ERR_API_INVALID_TOKEN.Error(), cerror.ERR_API_INVALID_TOKEN)
			return
		}
	})
}
