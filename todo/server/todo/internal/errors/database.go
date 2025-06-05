package errors

import "errors"

var (
	ERR_DB_USER_EXISTS                  = errors.New("User already exists.")
	ERR_DB_QUERY_FAILED                 = errors.New("Query failed.")
	ERR_DB_INSERT_FAILED                = errors.New("Query failed.")
	ERR_DB_EMAIL_TAKEN                  = errors.New("Email taken.")
	ERR_DB_DELETE_FAILED                = errors.New("Failed to delete.")
	ERR_DB_UPDATE_FAILED                = errors.New("Failed to update.")
	ERR_DB_TX_FAILED                    = errors.New("Transaction failed.")
	ERR_DB_USER_MISSING                 = errors.New("User missing.")
	ERR_DB_CANNOT_UPDATE_COMPLETED_TODO = errors.New("Unable to update completed todo.")
)
