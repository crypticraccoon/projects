package model

type Date struct {
	Year  string  `json:"year"`
	Month []Month `json:"month"`
}
type Month struct {
	Month string `json:"month"`
	Day   []Day  `json:"day"`
}
type Day struct {
	Day    string   `json:"day"`
	Period []Period `json:"period"`
}

type Period struct {
	Period   string     `json:"period"`
	Position []Position `json:"position"`
}

type Position struct {
	Position string   `json:"position"`
	Files    []string `json:"files"`
}

type Image struct {
	Year     string `json:"year"`
	Month    string `json:"month"`
	Day      string `json:"day"`
	Period   string `json:"period"`
	Position string `json:"position"`
	FileName string `json:"fileName"`
}

type ExtractImageModel struct {
	TargetPath      string `json:"targetPath"`
	ServerPath      string `json:"serverPath"`
	DestinationPath string `json:"destinationPath"`
	WatermarkPath   string `json:"watermarkPath"`
	Delimiter       string `json:"delimiter"`
	TimePeriod      string `json:"timePeriod"`
	Alpha           string `json:"alpha"`
	UploadToServer  bool   `json:"uploadToServer"`
}

type ImageCountModel struct {
	Delimiter       string `json:"delimiter"`
	TargetPath      string `json:"targetPath"`
	TimePeriod      string `json:"timePeriod"`
	DestinationPath string `json:"destinationPath"`
	JoinFolders     bool   `json:"joinFolders"`
}
