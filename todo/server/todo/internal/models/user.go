package models

import (
	"context"
	"net/mail"
	"server/internal/utils"
	"time"

	"github.com/gofrs/uuid"
	"golang.org/x/crypto/bcrypt"
)

type User struct {
	Id               uuid.UUID  `json:"id"`
	Username         string     `json:"username,omitempty"`
	Email            string     `json:"email"`
	Password         string     `json:"password"`
	IsVerified       bool       `json:"is_verified"`
	CreatedAt        time.Time  `json:"created_at"`
	DeletedAt        *time.Time `json:"deleted_at,omitempty"`
	RecoveryMode     bool       `json:"recover_mode"`
	RecoveryCode     int        `json:"recovery_code,omitempty"`
	RecoveredAt      *time.Time `json:"recovered_at,omitempty"`
	VerifiedAt       *time.Time `json:"verified_at,omitempty"`
	VerificationCode int        `json:"verification_code,omitempty"`
	RefreshToken     string     `json:"refresh_token,omitempty"`
}

type UserResponse struct {
	Id       uuid.UUID `json:"id"`
	Username string    `json:"username,omitempty"`
	Email    string    `json:"email"`
}

type Username struct {
	//Id       uuid.UUID `json:"id"`
	Username string `json:"username"`
}

type UserAdditionalData struct {
	//Id       uuid.UUID `json:"id"`
	Username string `json:"username"`
}

func (u *UserAdditionalData) IsValid() bool {
	if u.Username == "" {
		return false
	}
	return true

}

type RecoveryPassword struct {
	Password string `json:"password"`
}

func (p *RecoveryPassword) IsValid() bool {
	if p.Password != "" {
		return true
	}
	return false
}

type Password struct {
	//Id          uuid.UUID `json:"id"`
	Password    string `json:"password"`
	NewPassword string `json:"new_password"`
}

func (p *Password) IsValid() bool {
	if p.Password != "" && p.NewPassword != "" {
		return true
	}
	return false
}

type Email struct {
	//Id    uuid.UUID `json:"id"`
	Email string `json:"email"`
}

func (e *Recovery) IsValidEmail() bool {
	_, err := mail.ParseAddress(e.Email)
	return err == nil
}

func (e *Email) IsValidEmail() bool {
	_, err := mail.ParseAddress(e.Email)
	return err == nil
}

func NewUser(ctx context.Context, email, password string) (*User, error) {
	passwordHash, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}

	user := &User{
		Id:               uuid.Must(uuid.NewV4()),
		Email:            email,
		Password:         string(passwordHash),
		IsVerified:       false,
		CreatedAt:        time.Now().Local(),
		VerificationCode: utils.CreateCode(),
		RecoveryMode:     false,
	}

	return user, nil
}

func (u *User) CheckPassword(passwordHash, password string) error {
	if err := bcrypt.CompareHashAndPassword([]byte(passwordHash), []byte(password)); err != nil {
		return err
	}
	return nil

}

func (u *User) StripUser(user *User) *UserResponse {

	return &UserResponse{
		Id:       user.Id,
		Username: user.Username,
		Email:    user.Email,
	}
}

func (u *User) GenerateNewPassword(password string) (string, error) {
	passwordHash, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return "", err
	}
	return string(passwordHash), nil
}

type Recovery struct {
	Email string `json:"email"`
}
