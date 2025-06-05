package api

import (
	"encoding/json"
	"errors"
	"net/http"
	cerror "server/internal/errors"
	"server/internal/models"
	"server/internal/response"
	"server/internal/utils"
	"strconv"

	"github.com/go-chi/chi/v5"
	"github.com/gofrs/uuid"
	"github.com/jackc/pgx/v5"
)

const (
	TODO_UPDATED = "Todo updated."
	TODO_DELETED = "Todo deleted."
)

func (a *Api) getTodo(w http.ResponseWriter, r *http.Request) {

	id := uuid.FromStringOrNil(chi.URLParam(r, "id"))
	if id == uuid.Nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), cerror.ERR_API_MALFORMED_DATA)
		return
	}

	userId := uuid.FromStringOrNil(r.Context().Value("userID").(string))

	data, err := a.database.GetTodo(a.context, userId, id)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			response.WithError(w, http.StatusNotFound, err.Error(), err)
			return
		}
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_DB_QUERY_FAILED.Error(), err)
		return
	}

	response.WithJson(w, data)
}

func (a *Api) getTodoStats(w http.ResponseWriter, r *http.Request) {
	userId := uuid.FromStringOrNil(r.Context().Value("userID").(string))

	data, err := a.database.GetTodoStats(a.context, userId)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_DB_QUERY_FAILED.Error(), err)
		return
	}

	response.WithJson(w, data)
}

func (a *Api) createTodo(w http.ResponseWriter, r *http.Request) {
	println("create endpint hit")
	userId := uuid.FromStringOrNil(r.Context().Value("userID").(string))

	var data *models.Todo
	err := json.NewDecoder(r.Body).Decode(&data)
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}
	data.UserId = userId

	data = data.New(data)

	if err = a.database.CreateTodo(a.context, data); err != nil {

		if errors.Is(err, cerror.ERR_DB_USER_MISSING) {
			response.WithError(w, http.StatusForbidden, cerror.ERR_DB_USER_MISSING.Error(), cerror.ERR_DB_USER_MISSING)
			return
		}
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_DB_INSERT_FAILED.Error(), err)
		return
	}

	response.WithJson(w, data)
}

func (a *Api) getCompletedTodos(w http.ResponseWriter, r *http.Request) {
	userId := uuid.FromStringOrNil(r.Context().Value("userID").(string))

	size, err := strconv.Atoi(chi.URLParam(r, "size"))
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), cerror.ERR_API_MALFORMED_DATA)
		return
	}
	page, err := strconv.Atoi(chi.URLParam(r, "page"))
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), cerror.ERR_API_MALFORMED_DATA)
		return
	}

	totalCompletedTodos, err := a.database.GetCompletedTodosTotal(a.context, userId)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_DB_QUERY_FAILED.Error(), err)
		return
	}

	pData, err := utils.GetPagination(totalCompletedTodos, page, size)
	if err != nil {
		response.WithError(w, http.StatusNotFound, err.Error(), err)
		return
	}
	pagination := models.NewPagination(pData)

	completedTodos, err := a.database.GetCompletedTodos(a.context, userId, pagination)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_DB_QUERY_FAILED.Error(), err)
		return
	}

	response.WithJson(w, completedTodos)
}

func (a *Api) getTodosByDate(w http.ResponseWriter, r *http.Request) {
	userId := uuid.FromStringOrNil(r.Context().Value("userID").(string))

	date := chi.URLParam(r, "date")

	if !utils.CheckDate(date) {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), cerror.ERR_API_MALFORMED_DATA)
		return
	}

	size, err := strconv.Atoi(chi.URLParam(r, "size"))
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), cerror.ERR_API_MALFORMED_DATA)
		return
	}
	page, err := strconv.Atoi(chi.URLParam(r, "page"))
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), cerror.ERR_API_MALFORMED_DATA)
		return
	}

	total, err := a.database.GetTodosByDateTotal(a.context, userId, date)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_DB_QUERY_FAILED.Error(), err)
		return
	}
	pData, err := utils.GetPagination(total, page, size)
	if err != nil {
		if errors.Is(err, cerror.ERR_PAGINATION_NO_DATA) {
			response.WithJson(w, []models.Todo{})
			return
		}
		response.WithError(w, http.StatusNotFound, err.Error(), err)
		return
	}
	pagination := models.NewPagination(pData)

	todos, err := a.database.GetTodosByDate(a.context, userId, date, pagination)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_DB_QUERY_FAILED.Error(), err)
		return
	}

	response.WithJson(w, todos)
}

func (a *Api) updateTodo(w http.ResponseWriter, r *http.Request) {
	userId := uuid.FromStringOrNil(r.Context().Value("userID").(string))

	var data models.Todo
	err := json.NewDecoder(r.Body).Decode(&data)
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}

	data.UserId = userId
	isCompleted, err := a.database.IsTodoCompleted(a.context, data.UserId, data.Id)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_DB_UPDATE_FAILED.Error(), err)
		return
	}
	if isCompleted {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_DB_CANNOT_UPDATE_COMPLETED_TODO.Error(), cerror.ERR_DB_CANNOT_UPDATE_COMPLETED_TODO)
		return
	}

	err = a.database.UpdateTodo(a.context, &data)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_DB_UPDATE_FAILED.Error(), err)
		return
	}

	response.WithJson(w, TODO_UPDATED)
}

func (a *Api) completeTodo(w http.ResponseWriter, r *http.Request) {
	id := uuid.FromStringOrNil(chi.URLParam(r, "id"))
	if id == uuid.Nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), cerror.ERR_API_MALFORMED_DATA)
		return
	}
	userId := uuid.FromStringOrNil(r.Context().Value("userID").(string))

	err := a.database.CompleteTodo(a.context, userId, id)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_DB_UPDATE_FAILED.Error(), err)
		return
	}

	response.WithJson(w, TODO_UPDATED)
}

func (a *Api) deleteTodo(w http.ResponseWriter, r *http.Request) {
	id := uuid.FromStringOrNil(chi.URLParam(r, "id"))
	if id == uuid.Nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), cerror.ERR_API_MALFORMED_DATA)
		return
	}
	userId := uuid.FromStringOrNil(r.Context().Value("userID").(string))

	err := a.database.DeleteTodo(a.context, userId, id)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_DB_DELETE_FAILED.Error(), err)
		return
	}

	response.WithJson(w, TODO_DELETED)
}
