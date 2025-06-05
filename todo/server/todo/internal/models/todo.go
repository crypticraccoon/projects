package models

import (
	"server/internal/utils"
	"time"

	"github.com/gofrs/uuid"
)

type Todo struct {
	Id          uuid.UUID  `json:"id"`
	UserId      uuid.UUID  `json:"user_id"`
	Title       string     `json:"title"`
	Body        string     `json:"body"`
	Deadline    time.Time  `json:"deadline"`
	CreatedAt   time.Time  `json:"created_at"`
	CompletedAt *time.Time `json:"completed_at"`
	IsCompleted bool       `json:"is_completed"`
}

type TodoPaginated struct {
	TotalPages int     `json:"total_pages"`
	TotalItems int     `json:"total_items"`
	Data       *[]Todo `json:"data"`
}

func NewTodoPaginated(totalPages, totalItems int, data *[]Todo) *TodoPaginated {
	return &TodoPaginated{
		TotalPages: totalPages,
		TotalItems: totalItems,
		Data:       data,
	}
}

type TodoStats struct {
	Completed  int `json:"completed"`
	Inprogress int `json:"in_progress"`
}

func (t *Todo) New(data *Todo) *Todo {
	data.Id = uuid.Must(uuid.NewV4())
	data.IsCompleted = false
	data.CreatedAt = utils.GetTime()
	return data
}
