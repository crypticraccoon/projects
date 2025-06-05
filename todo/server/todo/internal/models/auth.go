package models

import (
	"net/mail"

	"github.com/gofrs/uuid"
)

type Login struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type LoginResponse struct {
	Id        uuid.UUID `json:"id"`
	TokenData TokenPair `json:"token_data"`
}

func (l *Login) Check() bool {
	if l.Email == "" || l.Password == "" {
		return false
	}
	_, err := mail.ParseAddress(l.Email)
	return err == nil
}

type Register struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

func (u *Register) IsEmpty() bool {
	if u.Email == "" || u.Password == "" {
		return true
	}

	return false
}

func (r *Register) IsValidEmail() bool {
	_, err := mail.ParseAddress(r.Email)
	return err == nil
}
