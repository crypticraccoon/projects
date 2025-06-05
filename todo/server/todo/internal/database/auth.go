package database

import (
	"context"
	cerror "server/internal/errors"
	"server/internal/models"

	"github.com/gofrs/uuid"
	"github.com/jackc/pgx/v5"
)

func (d *Database) RegisterUser(ctx context.Context, user *models.User) error {
	tx, err := d.conn.BeginTx(ctx, pgx.TxOptions{})
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)

	var exists bool
	println("=======")

	err = tx.QueryRow(ctx, "SELECT EXISTS(SELECT 1 FROM users WHERE email = $1)", user.Email).Scan(&exists)
	if err != nil {
		return err
	}

	println("=======")
	println(exists)
	if exists {
		println("exitst")
		return cerror.ERR_DB_USER_EXISTS
	}
	println(user.VerificationCode)
	_, err = tx.Exec(ctx,
		"INSERT INTO users (id, email, password, is_verified, created_at, verification_code ) VALUES ($1, $2, $3, $4, $5, $6)",
		user.Id, user.Email, user.Password, user.IsVerified, user.CreatedAt, user.VerificationCode)
	if err != nil {
		return err
	}

	if err = tx.Commit(ctx); err != nil {
		return err
	}
	return nil
}

func (d *Database) UpdateRefreshToken(ctx context.Context, id uuid.UUID, refreshToken string) error {
	sql := `UPDATE users SET refresh_token = $1 WHERE id = $2`
	_, err := d.conn.Exec(ctx, sql, refreshToken, id)
	if err != nil {
		return err
	}
	return nil
}

func (d *Database) GetRefreshToken(ctx context.Context, id uuid.UUID) (string, error) {

	var refreshToken string
	sql := `SELECT refresh_token FROM users WHERE id = $1`

	err := d.conn.QueryRow(ctx, sql, id).Scan(&refreshToken)
	if err != nil {
		return refreshToken, err
	}
	return refreshToken, nil
}

func (d *Database) RemoveRefreshToken(ctx context.Context, id uuid.UUID) error {
	sql := `UPDATE users SET refresh_token = $1 WHERE id = $2`
	_, err := d.conn.Exec(ctx, sql, "", id)
	if err != nil {
		return err
	}
	return nil
}
