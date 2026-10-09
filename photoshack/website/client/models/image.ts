export interface ImageCountModel {
	delimiter: string
	targetPath: string
	timePeriod: string
	destinationPath: string
	joinFolders: boolean


}



export interface ImageCountResponseModel {
	success: string
}

export interface ImageExtractModel {
	targetPath: string
	serverPath: string
	destinationPath: string
	watermarkPath: string
	delimiter: string
	timePeriod: string
	alpha: string
	uploadToServer: boolean
}



