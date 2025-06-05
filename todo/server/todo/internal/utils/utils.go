package utils

import (
	"math/rand"
	"os"
	"regexp"
	cerror "server/internal/errors"
	"time"

	"github.com/joho/godotenv"
)

func LoadEnv() error {
	appMode := os.Getenv("APPMODE")
	if appMode != "release" {
		err := godotenv.Load(".env")
		if err != nil {
			return err
		}
	}
	return nil
}

func GetTime() time.Time {
	return time.Now()

}

func CreateCode() int {
	verificationCode := 100000000000 + rand.Int63n(999999999998-100000000000+1)
	return int(verificationCode)
}

func CheckDate(date string) bool {
	regex := regexp.MustCompile(`^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$`)
	return regex.MatchString(date)
}

func GetPagination(totalItems, page, querySize int) (map[string]int, error) {

	if querySize == 0 {
		querySize = 1
	}

	var totalPages int = 0
	var skip int = 0

	//Total Pages
	if totalItems == 0 {
		return nil, cerror.ERR_PAGINATION_NO_DATA

	}
	totalPages = totalItems / querySize
	if totalItems%querySize != 0 {
		totalPages++
	}
	// Skip
	if page == 1 {
		skip = 0
	} else if page != 0 {
		skip = page*querySize - querySize
	}

	if page == totalPages && (totalItems%querySize) != 0 {
		querySize = totalItems % querySize
	} else if totalItems < querySize {
		skip = 0
		querySize = totalPages
	}
	if page > totalPages {
		return nil, cerror.ERR_PAGINATION_OUT_OF_BOUNDS
	}

	return map[string]int{
		"total_pages": totalPages,
		"skip":        skip,
		"query":       querySize,
	}, nil
}
