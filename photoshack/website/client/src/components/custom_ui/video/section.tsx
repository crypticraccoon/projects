"use client"
import { GetVideoThumbnail, GetVideoThumbnailsFileNames } from "@/api/videos"
import { Button } from "@/components/ui/button"
import Loading from "@/components/ui/loading"
import {
	Sheet,
	SheetContent,
	SheetDescription,
	SheetFooter,
	SheetHeader,
	SheetTitle,
	SheetTrigger,

} from "@/components/ui/sheet"
import { toast } from "@/hooks/use-toast"
import { DateModel } from "@/models/date"
import { ErrorModel } from "@/models/response"
import { VideoExtractResponseModel, } from "@/models/video"
import { VideoBlobModel, VideoThumbnailModel } from "@/models/thumbnail"
import { ERRORTITLE } from "@/utils/errors"
import { VideoIcon } from "@radix-ui/react-icons"
import Image from "next/image"
import { useEffect, useState } from "react"
import { Card, CardContent } from "@/components/ui/card"
import {
	Carousel,
	CarouselContent,
	CarouselItem,
	CarouselNext,
	CarouselPrevious,
} from "@/components/ui/carousel"
import { URL as apiUrl } from "@/utils/globals"

export function VideoSheet(props: any) {
	const [isLoading, setIsLoading] = useState<boolean>(true)
	const [togglePopUp, setTogglePopUp] = useState<boolean>(false)
	const [videoTitle, setVideoTitle] = useState<string>("")
	const [videoDescription, setVideoDescription] = useState<string>("")
	const [videoThumbnails, setVideoThumbnails] = useState<VideoBlobModel[]>([])
	const [toggleVideoPopUp, setVideoTogglePopUp] = useState<boolean>(false)
	const [videoPopUpData, setVideoPopUpData] = useState<VideoThumbnailModel>()


	useEffect(() => {
		setVideoTitle(`Video list`)
		setVideoDescription(`Date: ${(props.targetDate as DateModel).year}/${(props.targetDate as DateModel).month[0].month}/${(props.targetDate as DateModel).month[0].day[0].day} Period: ${props.period.period}`);
	}, [])


	function handleToggleVideoPopUp(data: VideoThumbnailModel) {
		setVideoPopUpData(data)
		setVideoTogglePopUp(toggleVideoPopUp ? false : true)
	}

	function handleTogglePopUp() {
		setTogglePopUp(togglePopUp ? false : true)
	}

	async function handleGetPeriodVideoThumbnaiils() {
		let date = props.targetDate as DateModel

		let res: VideoExtractResponseModel | ErrorModel = await GetVideoThumbnailsFileNames(date.year, date.month[0].month, date.month[0].day[0].day, props.period.period)
		if ((res as ErrorModel).error) {
			toast({
				title: ERRORTITLE,
				description: `Failed to fetch video thumbnails.`,
			})
			return
		}

		let thumbnailFileNames = (res as VideoExtractResponseModel).success

		let periodImages: VideoBlobModel[] = []
		for (let i in thumbnailFileNames) {

			let res: Blob | ErrorModel = await GetVideoThumbnail(date.year, date.month[0].month, date.month[0].day[0].day, props.period.period, thumbnailFileNames[i])

			if ((res as ErrorModel).error) {

			}
			let blobConverted = URL.createObjectURL(res as Blob)

			periodImages.push({
				blobUrl: blobConverted, fileName: thumbnailFileNames[i], thumbnailData: {
					year: date.year,
					month: date.month[0].month,
					day: date.month[0].day[0].day,
					period: props.period.period,
					fileName: thumbnailFileNames[i]

				}
			})
			periodImages = periodImages.sort((a, b) => parseInt(a.fileName.split(".")[0]) - parseInt(b.fileName.split(".")[0]))

		}
		setVideoThumbnails(periodImages)
		setIsLoading(false)
	}

	return (
		<>
			<Sheet>
				<SheetTrigger asChild>
					<Button onClick={async () => {
						await handleGetPeriodVideoThumbnaiils()
					}} variant="ghost"><VideoIcon /></Button>

				</SheetTrigger>
				<SheetContent className="sm:!max-w-[80%]">
					<SheetHeader>
						<SheetTitle>{videoTitle}</SheetTitle>
						<SheetDescription className="pb-[15px]">
							<b>
								{videoDescription}
							</b>
						</SheetDescription>
					</SheetHeader>
					{isLoading ? <Loading {...{ responsive: true, title: "Fetching thumbnails..." }} /> :
						<div className="flex w-full flex-wrap justify-center">
							{videoThumbnails.length === 0 ? <div>No videos found.</div> : videoThumbnails.map((e: VideoBlobModel) => {
								return <div className="m-[5px] w-[150px] h-[150px] duration-500 text-black hover:bg-black hover:opacity-40 hover:backdrop-blur-sm z-10 flex justify-center items-center flex-wrap relative cursor-pointer" onClick={() => {
									handleToggleVideoPopUp(e.thumbnailData)
									//handleTogglePopUp()
								}}>
									<h1 className="p-[5px] absolute bottom-0 right-0 text-white"><b>{e.fileName}</b></h1>


									<Image width={150} height={150} src={e.blobUrl} alt={""} />
								</div>
							})}

						</div>
					}
					<SheetFooter>
					</SheetFooter>
				</SheetContent >
			</Sheet >

			{togglePopUp ? <VideoCarousel {...{ videoThumbnails, handleTogglePopUp }} /> : null}

			{toggleVideoPopUp && videoPopUpData ? <VideoPopUp {...{ videoPopUpData, handleToggleVideoPopUp }} /> : null}
		</>
	)
}

function VideoCarousel(props: any) {
	return (
		<>
			<div className="fixed top-0 left-0 w-screen h-screen  backdrop-blur-sm flex cursor-pointer justify-center items-center z-[109]" onClick={(e) => { if (e.currentTarget === e.target) props.handleTogglePopUp() }}>
				<div className="h-[85%] cursor-default flex flex-row justify-center items-center">

					{<Carousel className="w-[36rem]">
						<CarouselContent>
							{props.videoThumbnails.map((e: VideoBlobModel, index: number) => {
								return <VideoCard {...{ ...props, e, index }} />
							})}
						</CarouselContent>
						<CarouselPrevious />
						<CarouselNext />
					</Carousel>}
				</div></div>
		</>

	)
}


function VideoCard(props: any) {
	const [toggleVideo, setToggleVideo] = useState<boolean>(false)
	function handleToggleVideo() {
		setToggleVideo(toggleVideo ? false : true)
	}
	return (

		<>
			<CarouselItem key={props.index}>
				<div className="p-1">
					<Card>
						<CardContent className="flex aspect-square items-center justify-center p-6">
							<div className="flex flex-col">
								<b>
									<h1 className="mb-2">{props.e.fileName.split(".")[0]}</h1>
								</b>
								<div onClick={() => { handleToggleVideo() }}>
									<Image src={props.e.blobUrl} alt="image" width={450} height={450} />
								</div>
							</div>
						</CardContent>
					</Card>
				</div>
			</CarouselItem>
			{toggleVideo ? <VideoPopUp /> : null}
		</>
	)
}

function VideoPopUp(props: any) {
	return (
		<div className="z-[99] fixed top-0 left-0 w-screen h-screen flex justify-center items-center cursor-pointer bg-red backdrop-blur-sm" onClick={(e) => {
			if (e.target === e.currentTarget) {
				props.handleToggleVideoPopUp()
			}
		}}>
			<div className="h-[50%] w-[80%] cursor-auto" >
				<video id="video" src={`${apiUrl}/video/stream/${props.videoPopUpData.year}/${props.videoPopUpData.month}/${props.videoPopUpData.day}/${props.videoPopUpData.period}/${(props.videoPopUpData.fileName).split(".")[0]}.MP4 `} autoPlay={true} typeof="video/mp4" controls={true} />
			</div>

		</div>
	)

}
