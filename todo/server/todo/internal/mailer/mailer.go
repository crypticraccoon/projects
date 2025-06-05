package mailer

import (
	"context"
	"crypto/tls"
	"server/internal/confs"

	gomail "gopkg.in/gomail.v2"
)

type Mailer struct {
	context context.Context
	config  *confs.Mailer
}

var Mail *Mailer

func NewMailer(ctx context.Context, config *confs.Mailer) {
	Mail = &Mailer{
		context: ctx,
		config:  config,
	}
}

func (m *Mailer) IsEnabled() bool {
	return m.config.Enabled
}

func (m *Mailer) SendEmailVerificationLink(ctx context.Context, redirectLink, email string) error {

	d := gomail.NewDialer(m.config.Host, m.config.Port, m.config.UserEmail, m.config.Password)
	d.TLSConfig = &tls.Config{InsecureSkipVerify: true}

	mail := gomail.NewMessage()
	mail.SetHeader("From", m.config.UserEmail)
	mail.SetHeader("To", email)
	mail.SetHeader("Subject", "Email verification link for todo app.")
	mail.SetBody("text/html", redirectLink)

	if err := d.DialAndSend(mail); err != nil {
		return err
	}

	return nil
}

func (m *Mailer) SendEmailRecoveryLink(ctx context.Context, redirectLink, email string) error {

	d := gomail.NewDialer(m.config.Host, m.config.Port, m.config.UserEmail, m.config.Password)
	d.TLSConfig = &tls.Config{InsecureSkipVerify: true}

	mail := gomail.NewMessage()
	mail.SetHeader("From", m.config.UserEmail)
	mail.SetHeader("To", email)
	mail.SetHeader("Subject", "Password recovery link for todo app.")
	mail.SetBody("text/html", redirectLink)

	if err := d.DialAndSend(mail); err != nil {
		return err
	}
	return nil
}
