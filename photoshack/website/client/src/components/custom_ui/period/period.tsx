"use client"
import Loading from "@/components/ui/loading"
import { ChevronDownIcon, ChevronUpIcon } from "@radix-ui/react-icons"
import { useEffect, useState } from "react"
import { VideoSheet } from "../video/section"
import { Button } from "@/components/ui/button"
import { ErrorModel } from "@/models/response"
import { GetVideoThumbnailsFileNames } from "@/api/videos"
import { DateModel, PeriodModel } from "@/models/date"
import { BlobModel, ThumbnailModel } from "@/models/thumbnail"
import { ERRORTITLE } from "@/utils/errors"
import { toast } from "@/hooks/use-toast"
import { ToastAction } from "@/components/ui/toast"
import { GetImage, GetThumbnail } from "@/api/photos"
import { Card, CardContent } from "@/components/ui/card"
import {
	Carousel,
	CarouselContent,
	CarouselItem,
	CarouselNext,
	CarouselPrevious,
} from "@/components/ui/carousel"


export function PeriodSection(props: any) {
	return (
		<section key={props.targetDate}>
			{props.targetDate?.month[0].day[0].period
				.map((period: any, index: any) => {
					return <PeriodHeader {...{ period, ...props, index }} />

				})

			}
		</section>

	)
}

function PeriodHeader(props: any) {
	const [isLoading, setIsLoading] = useState<Boolean>(false)
	const [imageThumbnails, setImageThumbnails] = useState<BlobModel[]>([])
	const [isExpanded, setIsExpanded] = useState<Boolean>(false)
	const [targetImage, setTargetImage] = useState<ThumbnailModel>()
	const [togglePopUp, setTogglePopUp] = useState<Boolean>(false)

	useEffect(() => {
		setIsExpanded(false)
	}, [props.targetDate])

	async function togglePhotos(period: PeriodModel, targetDate: DateModel) {
		if (isExpanded) {
			setIsExpanded(isExpanded ? false : true)
			return
		}

		setIsLoading(true)
		const thumbnailData: ThumbnailModel[] = []
		const periodImages: BlobModel[] = []
		const failedImages: ThumbnailModel[] = []

		for (let i in period.position) {
			let imageData: ThumbnailModel = {
				year: targetDate.year,
				month: targetDate.month[0].month,
				day: targetDate.month[0].day[0].day,
				period: period.period,
				position: period.position[i]
			}
			thumbnailData.push(imageData)
		}

		let blobs = await getImageThumbnails(thumbnailData, periodImages, failedImages)

		let convertedBlobs: BlobModel[] = []
		blobs.map((e: BlobModel) => {
			convertedBlobs.push(e)
		})
		convertedBlobs = convertedBlobs.sort((a, b) => parseInt(a.thumbnailData.position["position"]) - parseInt(b.thumbnailData.position["position"]))

		setImageThumbnails(convertedBlobs)
		setIsExpanded(isExpanded ? false : true)
		setIsLoading(false)
	}

	function handleTogglePopUp(data: ThumbnailModel) {
		setTogglePopUp(togglePopUp ? false : true)
		setTargetImage(data)
	}
	return <>{isLoading ? <Loading {...{ title: "Fetching pictures..." }} /> : <div key={props.index} >
		<div className="flex flex-col mt-[55px] px-[15px] md:px-[75px]">
			<header className="flex flex-row justify-between bg-accent m-[25px] p-[10px] items-center shadow-md">

				<div>
					<h1>Time: {props.period.period} &nbsp; 	&nbsp; People: {props.period.position.length}</h1>
				</div>
				<div className="flex flex-row items-center justify-center">
					<button onClick={async () => {
						await togglePhotos(props.period, props.targetDate)
					}
					}>
						{!isExpanded ? <ChevronDownIcon /> : <ChevronUpIcon />}</button>
					&nbsp; 	&nbsp;
					<VideoSheet {...{ ...props }} />
				</div>
			</header>
			{isExpanded ?
				<div key={Date.now()} className={
					"flex flex-wrap justify-center duration-500 overflow-hidden " + `${isExpanded ? "scale-100" : "scale-0 max-h-0"}`
				} >
					{
						imageThumbnails.map(e => {
							return <div className="cursor-pointer relative m-[5px]" onClick={() => {
								handleTogglePopUp(e.thumbnailData)
							}}>

								<div className="absolute duration-500 w-full h-full hover:bg-black hover:opacity-70 hover:backdrop-blur-sm z-10 flex justify-center items-center">
									<h1 className="p-[25px] absolute bottom-0 right-0 text-white">{e.thumbnailData.position.position}</h1>
								</div>
								<img src={e.blobUrl} alt="image" className="w-auto h-auto max-h-[350px] object-contain m-[5px]" />
							</div>
						})
					}
				</div> : null
			}
		</div>
		{togglePopUp ? <PopUpComponent{...{ targetImage, handleTogglePopUp }} /> : null}
	</div >
	}</>
}

function PopUpComponent(props: any) {
	const [isLoading, setIsLoading] = useState<Boolean>(true)
	const [images, setImages] = useState<{ blob: string, name: string }[]>([])
	let data = props.targetImage as ThumbnailModel
	useEffect(() => {
		(async () => {

			let convertedBlobs: { blob: string, name: string }[] = []
			for (let i in data.position.files) {
				let res: Blob | ErrorModel = await GetImage(data, data.position.files[i])
				if ((res as ErrorModel).error) {
					console.log((res as ErrorModel).error)
				} else {
					let blobConverted = URL.createObjectURL(res as Blob)
					convertedBlobs.push({ blob: blobConverted, name: data.position.files[i] })
				}

			}
			setImages(convertedBlobs)
		})()
		setIsLoading(false)
	}, [])
	return <div className="fixed top-0 left-0 w-screen h-screen  backdrop-blur-sm flex cursor-pointer justify-center items-center" onClick={(e) => { if (e.currentTarget === e.target) props.handleTogglePopUp() }}>
		<div className="h-[85%] cursor-default flex flex-row justify-center items-center">
			{isLoading ? <Loading /> :
				<Carousel className="w-[36rem]">
					<CarouselContent>
						{images.map((e, index) => {
							return <CarouselItem key={index}>
								<div className="p-1">
									<Card>
										<CardContent className="flex aspect-square items-center justify-center p-6">
											<div className="flex flex-col ">
												<b>
													<h1 className="mb-2">{e.name.split(".")[0]}</h1>
												</b>
												<img src={e.blob} alt="image" className="" />
											</div>
										</CardContent>
									</Card>
								</div>
							</CarouselItem>
						})}
					</CarouselContent>
					<CarouselPrevious />
					<CarouselNext />
				</Carousel>}
		</div>
	</div>
}

async function getImageThumbnails(thumbnailData: ThumbnailModel[], periodImages: BlobModel[], failedImages: ThumbnailModel[]) {
	for (let i in thumbnailData) {
		let res: Blob | ErrorModel = await GetThumbnail(thumbnailData[i])

		if ((res as ErrorModel).error) {
			failedImages.push(thumbnailData[i])
		} else {
			let blobConverted = URL.createObjectURL(res as Blob)
			periodImages.push({ blobUrl: blobConverted, thumbnailData: thumbnailData[i] } as BlobModel)
		}

	}
	if (failedImages.length !== 0) {
		toast({
			title: ERRORTITLE,
			description: `Failed to fetch ${failedImages.length} imageThumbnails.`,
			action: <ToastAction altText="Try again" onClick={async () => { await getImageThumbnails([], [], failedImages) }} >Try again</ToastAction>,
		})
	}
	return periodImages
}
