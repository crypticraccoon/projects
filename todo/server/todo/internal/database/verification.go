package database

import (
	"context"
	"server/internal/utils"

	"github.com/gofrs/uuid"
	"github.com/jackc/pgx/v5"
)

func (d *Database) IsUserRegistered(ctx context.Context, id uuid.UUID) (bool, error) {

	isRegisterd := false
	err := d.conn.QueryRow(ctx,
		`SELECT EXISTS(select * from users where username is not null AND id = $1)`, id).Scan(&isRegisterd)

	if err != nil {
		return false, err
	}

	return isRegisterd, nil
}

func (d *Database) CheckIfUserExist(ctx context.Context, id uuid.UUID, code int) (bool, error) {
	var exists bool
	err := d.conn.QueryRow(ctx, "SELECT EXISTS(SELECT 1 FROM users WHERE id = $1 AND verification_code = $2)", id, code).Scan(&exists)
	if err != nil {
		return false, err
	}

	if !exists {
		return false, nil
	}
	return exists, nil
}

func (d *Database) VerifyUserEmail(ctx context.Context, id uuid.UUID, code int) (bool, error) {

	tx, err := d.conn.BeginTx(ctx, pgx.TxOptions{})
	if err != nil {
		return false, err
	}
	defer tx.Rollback(ctx)

	var exists bool
	err = d.conn.QueryRow(ctx, "SELECT EXISTS(SELECT 1 FROM users WHERE id = $1 AND verification_code = $2)", id, code).Scan(&exists)
	if err != nil {
		return false, err
	}

	if !exists {
		return false, nil
	}

	_, err = tx.Exec(ctx,
		"UPDATE users SET is_verified=$1, verified_at=$2 WHERE id=$3",
		true, utils.GetTime(), id)

	if err != nil {
		return false, err
	}

	if err = tx.Commit(ctx); err != nil {
		return false, err
	}

	return exists, nil
}

func (d *Database) SetRecoveryCode(ctx context.Context, email string, code int) error {
	_, err := d.conn.Exec(ctx,
		"UPDATE users SET recovery_code=$1 WHERE email=$2",
		code, email)

	if err != nil {
		return err
	}
	return nil
}

func (d *Database) VerifyRecoveryEmail(ctx context.Context, email string, code int) (bool, error) {

	tx, err := d.conn.BeginTx(ctx, pgx.TxOptions{})
	if err != nil {
		return false, err
	}
	defer tx.Rollback(ctx)

	var exists bool
	err = d.conn.QueryRow(ctx, "SELECT EXISTS(SELECT 1 FROM users WHERE email = $1 AND recovery_code = $2)", email, code).Scan(&exists)
	if err != nil {
		return false, err
	}

	if !exists {
		return false, nil
	}

	_, err = tx.Exec(ctx,
		"UPDATE users SET recovered_at=$1 WHERE email=$2",
		utils.GetTime(), email)

	if err != nil {
		return false, err
	}

	if err = tx.Commit(ctx); err != nil {
		return false, err
	}

	return exists, nil
}
