import { ErrorModel } from "@/models/response"
import { VideoExtractModel, VideoExtractResponseModel } from "@/models/video"
import { APICALLFAILED } from "@/utils/errors"
import { URL } from "@/utils/globals"

export async function GetVideoThumbnail(year: string, month: string, day: string, period: string, fileName: string) {
	try {
		let res = await fetch(`${URL}/video/thumbnail/${year}/${month}/${day}/${period}/${fileName}`)
		if (res.status !== 200) {
			return await res.json() as ErrorModel
		}
		return await res.blob()
	} catch (e: any) {
		return { error: APICALLFAILED } as ErrorModel
	}
}

export async function GetVideoThumbnailsFileNames(year: string, month: string, day: string, period: string) {
	try {
		let res = await fetch(`${URL}/video/thumbnail/${year}/${month}/${day}/${period}`)
		if (res.status !== 200) {
			return await res.json() as ErrorModel
		}
		return await res.json() as VideoExtractResponseModel
	} catch (e: any) {
		return { error: APICALLFAILED } as ErrorModel
	}
}


export async function ExtractVideos(data: VideoExtractModel) {
	try {
		let res = await fetch(`${URL}/video/extract`,
			{
				method: "POST",
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify(data)
			}
		)
		if (res.status !== 200) {
			return await res.json() as ErrorModel
		}
		let body = await res.json()
		return body

	} catch (e: any) {
		return { error: APICALLFAILED } as ErrorModel
	}
}
