package errors

import "errors"

var (
	ERR_MISSING_ENV = errors.New("Missing env.")
)

var (
	ERR_API_MALFORMED_DATA        = errors.New("Invalid payload.")
	ERR_API_MALFORMED_EMAIL       = errors.New("Invalid email.")
	ERR_API_EMAIL_NOT_FOUND       = errors.New("Email not found.")
	ERR_API_FAILED_TO_CREATE_USER = errors.New("Failed to create user.")
	ERR_API_FAILED_TO_DELETE_USER = errors.New("Failed to delete user.")
	ERR_API_VERIFICATION_FAILED   = errors.New("Verification failed.")
	ERR_STORAGE_FILE_MISSING      = errors.New("Missing file.")

	ERR_API_FAILED_TO_SEND_RECOVERY_EMAIL = errors.New("Failed to send recovery email.")
	ERR_API_FAILED_UPDATE_USERNAME        = errors.New("Failed to update username")
	ERR_API_FAILED_TO_UPDATE_PASSWORD     = errors.New("Failed to update password")
	ERR_API_FAILED_TO_UPDATE_EMAIL        = errors.New("Failed to update email")
	ERR_API_FAILED_UPDATE_USER            = errors.New("Failed to update user.")

	ERR_API_MISSING_HEADER       = errors.New("Missing header.")
	ERR_API_INVALID_TOKEN        = errors.New("Invalid token.")
	ERR_API_INVALID_CREDENTIALS  = errors.New("Invalid credentials.")
	ERR_API_LOGIN_FAILED         = errors.New("Login failed.")
	ERR_API_TOKEN_REFRESH_FAILED = errors.New("Token refresh failed.")
	ERR_API_LOGOUT_FAILED        = errors.New("Logout failed.")
	ERR_API_USER_NOT_VERIFIED    = errors.New("User not verified.")
)

var (
	ERR_PAGINATION_OUT_OF_BOUNDS = errors.New("Out of bounds.")
	ERR_PAGINATION_NO_DATA       = errors.New("No data")
	ERR_PAYLOAD_EMPTY            = errors.New("Payload empty.")
)
