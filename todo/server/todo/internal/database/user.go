package database

import (
	"context"
	"server/internal/models"
	"server/internal/utils"

	"github.com/gofrs/uuid"
)

func (d *Database) IsEmailTaken(ctx context.Context, email string) (bool, error) {
	emailTaken := false
	sql := `SELECT EXISTS( SELECT * FROM users WHERE email = $1 )`
	err := d.conn.QueryRow(ctx, sql, email).Scan(&emailTaken)
	if err != nil {
		return emailTaken, err
	}
	return emailTaken, nil
}

func (d *Database) GetUserByCredentials(ctx context.Context, data *models.Login) (*models.User, error) {
	var user models.User
	sql := `SELECT id, email, password,is_verified FROM users WHERE email = $1`
	err := d.conn.QueryRow(ctx, sql, data.Email).Scan(&user.Id, &user.Email, &user.Password, &user.IsVerified)
	if err != nil {
		return nil, err
	}

	return &user, nil
}

func (d *Database) GetUser(ctx context.Context, id uuid.UUID) (*models.User, error) {
	var user models.User
	sql := `SELECT id, email, username FROM users WHERE id = $1`
	err := d.conn.QueryRow(ctx, sql, id).Scan(&user.Id, &user.Email, &user.Username)
	if err != nil {
		return nil, err
	}

	return &user, nil
}

func (d *Database) GetPasswordHash(ctx context.Context, id uuid.UUID) (string, error) {
	var passwordHash string
	sql := `SELECT password FROM users WHERE id = $1`
	err := d.conn.QueryRow(ctx, sql, id).Scan(&passwordHash)
	if err != nil {
		return "", err
	}
	return passwordHash, nil
}

func (d *Database) UpdateRecoveryPassword(ctx context.Context, email, password string) error {
	sql := `UPDATE users SET password = $1 WHERE email = $2`
	_, err := d.conn.Exec(ctx, sql, password, email)
	if err != nil {
		return err
	}
	return nil
}

func (d *Database) ToggleRecoveryMode(ctx context.Context, email string, recoverMode bool) error {
	sql := `UPDATE users SET recovery_mode = $1 WHERE email = $2`

	_, err := d.conn.Exec(ctx, sql, recoverMode, email)
	if err != nil {
		return err
	}
	return nil
}

func (d *Database) GetRecoveryStatus(ctx context.Context, email string, code int) (bool, error) {
	var recoverMode bool
	sql := `SELECT recovery_mode FROM users WHERE recovery_mode = true AND email = $1 AND recovery_code = $2`

	err := d.conn.QueryRow(ctx, sql, email, code).Scan(&recoverMode)
	if err != nil {
		return recoverMode, err
	}
	return recoverMode, nil
}

func (d *Database) UpdatePassword(ctx context.Context, id uuid.UUID, password string) error {
	sql := `UPDATE users SET password = $1 WHERE id = $2`
	_, err := d.conn.Exec(ctx, sql, password, id)
	if err != nil {
		return err
	}
	return nil
}

func (d *Database) UpdateUsername(ctx context.Context, id uuid.UUID, username string) error {
	sql := `UPDATE users SET username = $1 WHERE id = $2`
	_, err := d.conn.Exec(ctx, sql, username, id)
	if err != nil {
		return err
	}
	return nil
}

func (d *Database) UpdateUserAdditionalData(ctx context.Context, data *models.UserAdditionalData, id uuid.UUID) error {
	sql := `UPDATE users SET username = $1 WHERE id = $2`
	_, err := d.conn.Exec(ctx, sql, data.Username, id)
	if err != nil {
		return err
	}
	return nil
}

func (d *Database) UpdateEmail(ctx context.Context, id uuid.UUID, email string) error {
	sql := `UPDATE users SET email = $1 WHERE id = $2`
	_, err := d.conn.Exec(ctx, sql, email, id)
	if err != nil {
		return err
	}
	return nil
}

func (d *Database) DeleteUser(ctx context.Context, id uuid.UUID) error {
	sql := `UPDATE users SET deleted_at = $1 WHERE id = $2`
	_, err := d.conn.Exec(ctx, sql, utils.GetTime().String(), id)
	if err != nil {
		return err
	}
	return nil
}
