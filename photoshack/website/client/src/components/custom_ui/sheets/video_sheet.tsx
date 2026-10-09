'use client'
import { Button } from "@/components/ui/button"
import {
	Tooltip,
	TooltipContent,
	TooltipProvider,
	TooltipTrigger,
} from "@/components/ui/tooltip"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import {
	Sheet,
	SheetClose,
	SheetContent,
	SheetDescription,
	SheetFooter,
	SheetHeader,
	SheetTitle,
	SheetTrigger,
} from "@/components/ui/sheet"
import { Switch } from "@/components/ui/switch"
import {
	Select,
	SelectContent,
	SelectItem,
	SelectTrigger,
	SelectValue,
} from "@/components/ui/select"
import { ALPHAVALUE, SERVERPATH, WATERMARKPATH, VIDEOTARGETPATH, VIDEODESTINATIONPATH, TOASTERRORTITLE, } from "@/utils/globals"
import { TransformIcon } from "@radix-ui/react-icons"
import { toast as sonner } from "sonner"

import { ExtractVideos } from "@/api/videos"
import { useState } from "react"
import { VideoExtractModel, VideoExtractResponseModel } from "@/models/video"
import { ErrorModel } from "@/models/response"
import { toast } from "@/hooks/use-toast"
import { ERR_MISSING_FIELD, ERR_MISSING_PERIOD } from "@/utils/errors"


export function VideoExtractButtonComponent() {
	return (<TooltipProvider>
		<Tooltip>
			<TooltipTrigger asChild>
				<Button variant="outline">
					<TransformIcon />
				</Button>
			</TooltipTrigger>
			<TooltipContent>
				<p>Extract Videos</p>
			</TooltipContent>
		</Tooltip>
	</TooltipProvider>
	)
}
export function VideoExtractSheetComponent() {
	const [timePeriod, setTimePeriod] = useState("")
	const [targetPath, setTargetPath] = useState(VIDEOTARGETPATH)
	const [destinationPath, setDestinationPath] = useState(VIDEODESTINATIONPATH)
	const [serverPath, setServerPath] = useState(SERVERPATH)
	const [watermarkPath, setWatermarkPath] = useState(WATERMARKPATH)
	const [alpha, setAlpha] = useState(ALPHAVALUE)
	const [uploadToServer, setUploadToServer] = useState(false)
	const [toggleExtractButton, setToggleExtractButton] = useState(false)
	const [joinPeriod, setJoinPeriod] = useState(false)

	function createExtractModel() {
		return {
			destinationPath,
			timePeriod,
			uploadToServer,
			serverPath,
			alpha,
			targetPath,
			watermarkPath,
			append: joinPeriod
		} as VideoExtractModel
	}
	function checkExtractModel(data: VideoExtractModel) {
		console.log(data)
		if (data.timePeriod === "") {
			return ERR_MISSING_PERIOD
		} else if (data.watermarkPath === "" || data.serverPath === "" || data.destinationPath === "" || data.alpha === "" || data.targetPath === "") {
			return ERR_MISSING_FIELD
		}
		return
	}


	async function extractVideosWrapper() {
		setTimePeriod("")
		const modelData = createExtractModel()
		const modelCheck = checkExtractModel(modelData)
		if (modelCheck) {
			return toast({
				title: TOASTERRORTITLE,
				description: modelCheck,
			})
		}
		let extractVideos = async (data: VideoExtractModel) => {
			let res: VideoExtractResponseModel | ErrorModel = await ExtractVideos(data)
			return res
		}

		setToggleExtractButton(true)

		const promise = () => new Promise((resolve) => setTimeout(async () => {
			resolve(
				await extractVideos(modelData)
			)
		}
		));
		sonner.promise(promise, {
			loading: 'Extracting videos...',
			success: (e) => {
				if ((e as ErrorModel).error) {
					return (e as ErrorModel).error
				}

				return `Videos successfully extracted!`;
			},
			error: 'Failed to extract videos. Please try again.',
		});
		setToggleExtractButton(false)
	}

	return (
		<Sheet>
			<SheetTrigger asChild>
				<button> <VideoExtractButtonComponent /> </button>
			</SheetTrigger>
			<SheetContent>
				<SheetHeader>
					<SheetTitle>Extract Videos</SheetTitle>
					<SheetDescription>
						Extract videos from SD card, modify, upload and serve.
					</SheetDescription>
				</SheetHeader>
				<div className="grid gap-4 py-4">
					<div className="flex flex-row justify-between items-center">
						<Label htmlFor="time_period" >
							<b>
								Time Period
							</b>
						</Label>
						<Select onValueChange={e => { setTimePeriod(e) }}>
							<SelectTrigger className="w-[180px]">
								<SelectValue placeholder="Choose Time" />
							</SelectTrigger>
							<SelectContent>
								<SelectItem value="9.15">9.15</SelectItem>
								<SelectItem value="10.15">10.15</SelectItem>
								<SelectItem value="11.15">11.15</SelectItem>
								<SelectItem value="12.15">12.15</SelectItem>
								<SelectItem value="13.15">13.15</SelectItem>
								<SelectItem value="14.15">14.15</SelectItem>
							</SelectContent>
						</Select>
					</div>
					<div>
						<Label htmlFor="target_path">
							<b>
								Target Path
							</b>
						</Label>
						<Input id="target_path" value={targetPath} onChange={e => { setTargetPath(e.target.value) }} className="col-span-3" />
					</div>

					<div>
						<Label htmlFor="destination_path" className="text-right">
							<b>
								Destination Path
							</b>
						</Label>
						<Input id="destination_path" value={destinationPath} onChange={e => { setDestinationPath(e.target.value) }}
						/>
					</div>
					<div>
						<Label htmlFor="server_path" >
							<b>
								Server Path
							</b>
						</Label>
						<Input id="server_path" value={serverPath} onChange={e => { setServerPath(e.target.value) }}
						/>
					</div>
					<div>
						<Label htmlFor="watermark_path" >
							<b>
								Watermark Path
							</b>
						</Label>
						<Input id="watermark_path" value={watermarkPath} onChange={e => { setWatermarkPath(e.target.value) }}
						/>
					</div>
					<div>
						<Label htmlFor="alpha_value" >
							<b>
								Alpha
							</b>
						</Label>
						<Input id="alpha_value" value={alpha} onChange={e => { setAlpha(e.target.value) }}
						/>
					</div>
				</div>
				<div className="flex justify-between my-[15px]">
					<Label htmlFor="join_period">
						<b>
							Merge Time Period
						</b>
					</Label>
					<Switch id="join_period" checked={joinPeriod} onCheckedChange={e => { setJoinPeriod(e) }} />
				</div>


				<div className="flex justify-between my-[15px]">
					<Label htmlFor="video_upload">
						<b>
							Upload to server
						</b>
					</Label>
					<Switch id="video_upload" checked={uploadToServer} onCheckedChange={e => { setUploadToServer(e) }} />
				</div>

				<SheetFooter>
					<SheetClose asChild>
						<Button type="submit" disabled={toggleExtractButton} onClick={async () => { await extractVideosWrapper() }}>Extract</Button>
					</SheetClose>
				</SheetFooter>
			</SheetContent>
		</Sheet>
	)
}
