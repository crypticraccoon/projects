import { PositionModel } from "./date"


export interface VideoThumbnailModel {
	year: string,
	month: string,
	day: string,
	period: string,
	fileName: string
}
export interface ThumbnailModel {
	year: string,
	month: string,
	day: string,
	period: string,
	position: PositionModel
}

//export interface VideoBlobModel {
//blobUrl: string
//blobName: string
//}

export interface VideoBlobModel {
	blobUrl: string
	fileName: string
	thumbnailData: VideoThumbnailModel

}

export interface BlobModel {
	blobUrl: string
	thumbnailData: ThumbnailModel
}
