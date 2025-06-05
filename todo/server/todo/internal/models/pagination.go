package models

type Pagination struct {
	TotalPages int `json:"total_pages"`
	Skip       int `json:"skip"`
	Query      int `json:"query"`
}

func NewPagination(data map[string]int) *Pagination {
	return &Pagination{
		TotalPages: data["total_pages"],
		Skip:       data["skip"],
		Query:      data["query"],
	}
}
