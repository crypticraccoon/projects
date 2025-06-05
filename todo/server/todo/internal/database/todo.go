package database

import (
	"context"
	cerror "server/internal/errors"
	"server/internal/models"
	"server/internal/utils"

	"github.com/gofrs/uuid"
	"github.com/jackc/pgx/v5"
)

func (d *Database) CreateTodo(ctx context.Context, data *models.Todo) error {

	tx, err := d.conn.BeginTx(ctx, pgx.TxOptions{})
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)

	var exists bool
	err = tx.QueryRow(ctx, "SELECT EXISTS(SELECT 1 FROM users WHERE id = $1)", data.UserId).Scan(&exists)
	if err != nil {
		return err
	}

	if !exists {
		return cerror.ERR_DB_USER_MISSING
	}

	sql := `
	INSERT 
	INTO 
	todos (id, title, body, deadline, created_at, completed_at, is_completed, user_id) 
	VALUES ($1, $2, $3, $4, $5, $6, $7, $8) ;
	`
	_, err = d.conn.Exec(ctx, sql,
		data.Id,
		data.Title,
		data.Body,
		data.Deadline,
		data.CreatedAt,
		data.CompletedAt,
		data.IsCompleted,
		data.UserId)

	if err != nil {
		return err
	}

	return nil
}

func (d *Database) GetTodo(ctx context.Context, userId uuid.UUID, id uuid.UUID) (*models.Todo, error) {
	var data models.Todo
	sql := `SELECT id, user_id, title, body, deadline, created_at, completed_at, is_completed FROM todos WHERE id = $1 AND user_id = $2`
	err := d.conn.QueryRow(ctx, sql, id, userId).Scan(
		&data.Id,
		&data.UserId,
		&data.Title,
		&data.Body,
		&data.Deadline,
		&data.CreatedAt,
		&data.CompletedAt,
		&data.IsCompleted)
	if err != nil {
		return nil, err
	}

	return &data, nil
}

func (d *Database) GetTodoStats(ctx context.Context, userId uuid.UUID) (*models.TodoStats, error) {
	var data models.TodoStats

	sql := `
	SELECT
	COUNT(CASE WHEN is_completed = $1 THEN 1 END) AS completed,
	COUNT(CASE WHEN is_completed = $2 THEN 1 END) AS in_progress 
	FROM todos
	WHERE user_id = $3
	`
	err := d.conn.QueryRow(ctx, sql, true, false, userId).Scan(&data.Completed, &data.Inprogress)
	if err != nil {
		return nil, err
	}

	return &data, nil
}

func (d *Database) GetCompletedTodosTotal(ctx context.Context, userId uuid.UUID) (int, error) {

	sql := `
	SELECT COUNT(*) 
	FROM todos
	WHERE user_id = $1 AND is_completed = $2`

	var totalCompleted int = 0
	err := d.conn.QueryRow(ctx, sql, userId, true).Scan(&totalCompleted)
	if err != nil {
		return totalCompleted, err
	}
	return totalCompleted, nil
}

func (d *Database) GetCompletedTodos(ctx context.Context, userId uuid.UUID, paginationData *models.Pagination) (*[]models.Todo, error) {

	var resData []models.Todo

	sql := `
	SELECT id, user_id, title, body, deadline, created_at, completed_at, is_completed 
	FROM todos
	WHERE user_id = $1 AND is_completed = $4
	ORDER BY completed_at DESC
	LIMIT $2
	OFFSET $3;
	`

	rows, err := d.conn.Query(ctx, sql, userId, paginationData.Query, paginationData.Skip, true)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {

		var item models.Todo
		err = rows.Scan(
			&item.Id,
			&item.UserId,
			&item.Title,
			&item.Body,
			&item.Deadline,
			&item.CreatedAt,
			&item.CompletedAt,
			&item.IsCompleted)
		if err != nil {
			return nil, err
		}

		resData = append(resData, item)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return &resData, nil
}

func (d *Database) GetTodosByDateTotal(ctx context.Context, userId uuid.UUID, date string) (int, error) {

	sql := `
	SELECT COUNT(*) 
	FROM todos
	WHERE 
	DATE(deadline) = $1 AND user_id = $2
`
	var total int = 0
	err := d.conn.QueryRow(ctx, sql, date, userId).Scan(&total)
	if err != nil {
		return total, err
	}

	return total, nil
}

func (d *Database) GetTodosByDate(ctx context.Context, userId uuid.UUID, date string, paginationData *models.Pagination) (*[]models.Todo, error) {

	var resData []models.Todo

	sql := `
	SELECT id, user_id, title, body, deadline, created_at, completed_at, is_completed 
	FROM todos
	WHERE DATE(deadline) = $1 AND user_id = $2
	ORDER BY completed_at DESC
	LIMIT $3
	OFFSET $4;
	`

	rows, err := d.conn.Query(ctx, sql, date, userId, paginationData.Query, paginationData.Skip)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {

		var item models.Todo
		err = rows.Scan(
			&item.Id,
			&item.UserId,
			&item.Title,
			&item.Body,
			&item.Deadline,
			&item.CreatedAt,
			&item.CompletedAt,
			&item.IsCompleted)
		if err != nil {
			return nil, err
		}

		resData = append(resData, item)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return &resData, nil
}

func (d *Database) CompleteTodo(ctx context.Context, userId uuid.UUID, id uuid.UUID) error {
	sql := `
	UPDATE todos
	SET completed_at = $1, is_completed = $2
	WHERE id = $3 AND user_id = $4`
	_, err := d.conn.Exec(ctx, sql, utils.GetTime(), true, id, userId)
	if err != nil {
		return err
	}
	return nil
}

func (d *Database) IsTodoCompleted(ctx context.Context, userId, id uuid.UUID) (bool, error) {

	isCompleted := false
	sql := `SELECT EXISTS( SELECT * FROM todos WHERE id = $1 AND user_id = $2 and is_completed = $3)`
	err := d.conn.QueryRow(ctx, sql, id, userId, true).Scan(&isCompleted)
	if err != nil {
		return isCompleted, err
	}
	return isCompleted, nil

}

func (d *Database) UpdateTodo(ctx context.Context, data *models.Todo) error {

	sql := `
	UPDATE todos
	SET title = $1, body = $2, deadline = $3 
	WHERE id = $4 AND user_id = $5`
	_, err := d.conn.Exec(ctx, sql, data.Title, data.Body, data.Deadline, data.Id, data.UserId)
	if err != nil {
		return err
	}
	return nil

}

func (d *Database) DeleteTodo(ctx context.Context, userId uuid.UUID, id uuid.UUID) error {
	sql := `
	DELETE FROM todos
	WHERE id = $1 AND user_id = $2`
	_, err := d.conn.Exec(ctx, sql, id, userId)
	if err != nil {
		return err
	}
	return nil

}
