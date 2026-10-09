package model

type VideoScriptModel struct {
	TargetPath      string `json:"targetPath"`
	ServerPath      string `json:"serverPath"`
	DestinationPath string `json:"destinationPath"`
	WatermarkPath   string `json:"watermarkPath"`
	TimePeriod      string `json:"timePeriod"`
	Alpha           string `json:"alpha"`
	Append          bool   `json:"append"`
	UploadToServer  bool   `json:"uploadToServer"`
}
