


export interface VideoExtractModel {
	targetPath: string
	serverPath: string
	destinationPath: string
	watermarkPath: string
	timePeriod: string
	alpha: string
	uploadToServer: boolean
	append: boolean
}

export interface VideoExtractResponseModel {
	success: string[]
}


