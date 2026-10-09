package utilities

import (
	"os"
	"ps_image/internal/misc"
)

func RemoveDSStore(arr []os.DirEntry) []os.DirEntry {
	for posIndex, position := range arr {
		if position.Name() == misc.DIRTYFILE {
			arr = arr[:posIndex+copy(arr[posIndex:], arr[posIndex+1:])]
		}
	}
	return arr
}
