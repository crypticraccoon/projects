import { URL } from "@/utils/globals"
import { ErrorModel } from "@/models/response"
import { APICALLFAILED } from "@/utils/errors"
import { ThumbnailModel } from "@/models/thumbnail"
import { ImageCountModel, ImageExtractModel } from "@/models/image"



export async function GetThumbnail(data: ThumbnailModel) {
	try {
		let res = await fetch(`${URL}/image/thumbnail`, {
			method: "POST",
			headers: {
				'Accept': 'application/json',
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({
				"year": data.year,
				"month": data.month,
				"day": data.day,
				"period": data.period,
				"position": data.position.position
			})
		})

		if (res.status !== 200) {
			return await res.json() as ErrorModel
		}

		return await res.blob()
	} catch (e: any) {
		return { error: APICALLFAILED } as ErrorModel
	}
}

export async function GetImage(data: ThumbnailModel, fileName: string) {
	try {
		let res = await fetch(`${URL}/image`, {
			method: "POST",
			headers: {
				'Accept': 'application/json',
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({
				"year": data.year,
				"month": data.month,
				"day": data.day,
				"period": data.period,
				"position": data.position.position,
				"fileName": fileName
			})
		})

		if (res.status !== 200) {
			return await res.json() as ErrorModel
		}

		return await res.blob()
	} catch (e: any) {
		return { error: APICALLFAILED } as ErrorModel
	}
}

export async function GetImageCount(data: ImageCountModel) {
	try {
		let res = await fetch(`${URL}/image/count`, {
			method: "POST",
			headers: {
				'Accept': 'application/json',
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(
				data
			)
		})

		if (res.status !== 200) {
			return await res.json() as ErrorModel
		}

		return await res.json()
	} catch (e: any) {
		return { error: APICALLFAILED } as ErrorModel
	}
}

export async function ExtractImages(data: ImageExtractModel) {
	try {
		let res = await fetch(`${URL}/image/extract`, {
			method: "POST",
			headers: {
				'Accept': 'application/json',
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(data)
		})

		if (res.status !== 200) {
			return await res.json() as ErrorModel
		}

		return await res.json()
	} catch (e: any) {
		return { error: APICALLFAILED } as ErrorModel
	}
}

