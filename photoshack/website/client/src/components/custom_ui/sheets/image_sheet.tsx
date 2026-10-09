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
import { CropIcon } from "@radix-ui/react-icons"
import { Switch } from "@/components/ui/switch"
import {
	Select,
	SelectContent,
	SelectItem,
	SelectTrigger,
	SelectValue,
} from "@/components/ui/select"
import { useState } from "react"

import { ImageCountModel, ImageCountResponseModel, ImageExtractModel } from "@/models/image"
import { ErrorModel } from "@/models/response"
import { toast } from "@/hooks/use-toast"
import { ALPHAVALUE, DELIMITERVALUE, IMAGEDESTINATIONPATH, IMAGETARGETPATH, SERVERPATH, TOASTERRORTITLE, WATERMARKPATH } from "@/utils/globals"
import { ToastAction } from "@radix-ui/react-toast"
import { ExtractImages, GetImageCount } from "@/api/photos"
import { toast as sonner } from "sonner"
import { ERR_MISSING_FIELD, ERR_MISSING_PERIOD } from "@/utils/errors"

export function ImageExtractButtonComponent() {
	return (
		<TooltipProvider>
			<Tooltip>
				<TooltipTrigger asChild>
					<Button variant="outline">
						<CropIcon />
					</Button>
				</TooltipTrigger>
				<TooltipContent>
					<p>Extract Images</p>
				</TooltipContent>
			</Tooltip>
		</TooltipProvider>
	)
}

export function ImageExtractSheetComponent() {
	const [personCount, setPersonCount] = useState(0)
	const [extractButtonDisabled, setExtractButtonDisabled] = useState(true)
	const [timestamp, setTimestamp] = useState("")
	const [data, setData] = useState<ImageExtractModel>({} as ImageExtractModel)

	function handleDisableExtractButton(state: boolean) {
		setExtractButtonDisabled(state)
	}

	function handleSetData(data: ImageExtractModel) {
		setData(data)
	}

	function handleSetPersonCount(count: number) {
		setPersonCount(count)
		setTimestamp(new Date().toTimeString())
	}


	async function checkData(data: ImageExtractModel) {
		if (data.timePeriod === "") {
			return ERR_MISSING_PERIOD
		} else if (data.delimiter === "" || data.targetPath === "" || data.destinationPath === "" || data.alpha === "" || data.serverPath === "" || data.watermarkPath === "") {
			return ERR_MISSING_FIELD
		}
		return

	}
	async function extractImagesWrapper() {
		const fData = data
		const modelCheck = await checkData(fData)
		if (modelCheck) {
			return toast({
				title: TOASTERRORTITLE,
				description: modelCheck,
			})
		}
		let extractImages = async (data: ImageExtractModel) => await ExtractImages(data)
		const promise = () => new Promise((resolve) => setTimeout(async () => {
			resolve(
				await extractImages(fData)
			)
		}
		));
		sonner.promise(promise, {
			loading: 'Extracting images...',
			success: (e) => {
				if ((e as ErrorModel).error) {
					return (e as ErrorModel).error
				}

				return `Images successfully extracted!`;
			},
			error: 'Failed to extract images. Please try again.',
		});

	}


	return (
		<Sheet>
			<SheetTrigger asChild>
				<button> <ImageExtractButtonComponent /> </button>
			</SheetTrigger>
			<SheetContent>
				<SheetHeader>
					<SheetTitle>Extract Images</SheetTitle>
					<SheetDescription>

						<p>
							Extract images from SD card, modify, sort and serve.
						</p>

						<br />
						<b className="flex flex-row">
							Found a total of <p className="text-primary">&nbsp; {personCount} &nbsp;</p> folders.
						</b>
						<b>
							{timestamp === "" ? "" : <p className="flex flex-row">Last checked:&nbsp;<p className="text-primary">{timestamp.split(" ")[0]}</p></p>}
						</b>


					</SheetDescription>
				</SheetHeader>
				<ImageExtractBodyComponent {...{ personCount, handleSetPersonCount, GetImageCount, handleDisableExtractButton, handleSetData }} />
				<SheetFooter>
					<SheetClose asChild>
						<Button type="submit" disabled={extractButtonDisabled} onClick={async () => { await extractImagesWrapper() }}>Extract</Button>
					</SheetClose>
				</SheetFooter>
			</SheetContent>
		</Sheet>
	)
}
export function ImageExtractBodyComponent(props: any) {
	const [timePeriod, setTimePeriod] = useState("")
	const [delimiter, setDelimter] = useState(DELIMITERVALUE)
	const [targetPath, setTargetPath] = useState(IMAGETARGETPATH)
	const [destinationPath, setDestinationPath] = useState(IMAGEDESTINATIONPATH)
	const [serverPath, setServerPath] = useState(SERVERPATH)
	const [watermarkPath, setWatermarkPath] = useState(WATERMARKPATH)
	const [alpha, setAlpha] = useState(ALPHAVALUE)
	const [uploadToServer, setUploadToServer] = useState(false)
	const [joinFolders, setJoinFolders] = useState(false)
	const [countButtonDisabled, setCountButtonDisabled] = useState(false)


	function createCountModel() {
		return {
			delimiter: delimiter,
			targetPath: targetPath,
			destinationPath: destinationPath,
			joinFolders: joinFolders,
			timePeriod: timePeriod
		} as ImageCountModel
	}

	function checkCountData(data: ImageCountModel) {
		if (data.timePeriod === "") {
			return ERR_MISSING_PERIOD
		} else if (data.delimiter === "" || data.targetPath === "" || data.destinationPath === "") {
			return ERR_MISSING_FIELD
		}
		return
	}

	function setData(data: ImageExtractModel) {
		props.handleSetData(data)
	}

	async function getImageCountWrapper() {
		props.handleDisableExtractButton(true)

		const modelData = createCountModel()
		let modelCheck = checkCountData(modelData)
		if (modelCheck) {
			return toast({
				title: TOASTERRORTITLE,
				description: modelCheck,
			})


		}
		let getCountRes = async (data: ImageCountModel) => {
			let res: ImageCountResponseModel | ErrorModel = await GetImageCount(data)
			return res
		}
		setCountButtonDisabled(true)
		let res = await getCountRes(modelData)
		setCountButtonDisabled(false)
		if ((res as ErrorModel).error) {
			toast({
				title: TOASTERRORTITLE,
				description: (res as ErrorModel).error,
				action: <ToastAction altText="Try again" onClick={async () => { await getCountRes(modelData) }} >Try again</ToastAction>,
			})
			return
		}
		let fData: ImageExtractModel = {
			destinationPath,
			timePeriod,
			uploadToServer,
			serverPath,
			alpha,
			targetPath,
			watermarkPath,
			delimiter
		}
		setData(fData)
		props.handleSetPersonCount((res as ImageCountResponseModel).success)
		props.handleDisableExtractButton(false)
		return

	}


	return (
		<>
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
					<Label htmlFor="delimiter" >
						<b>
							Delimiter
						</b>
					</Label>
					<Input id="delimiter" value={delimiter} onChange={e => { setDelimter(e.target.value) }} />
				</div>
				<div>
					<Label htmlFor="target_path">
						<b>
							Target Path
						</b>
					</Label>
					<Input id="target_path" value={targetPath} className="col-span-3" onChange={e => { setTargetPath(e.target.value) }} />
				</div>

				<div>
					<Label htmlFor="destination_path" className="text-right">
						<b>
							Destination Path
						</b>
					</Label>
					<Input id="destination_path" value={destinationPath} onChange={e => { setDestinationPath(e.target.value) }} />
				</div>

				<div className="flex justify-between my-[15px]">
					<Label htmlFor="join_folders">
						<b>
							Join Folders
						</b>
					</Label>
					<Switch id="join_folders" checked={joinFolders} onCheckedChange={e => { setJoinFolders(e) }} />

				</div>

				<Button onClick={async () => { await getImageCountWrapper() }} disabled={countButtonDisabled}> Check Count </Button>

				<div>
					<Label htmlFor="watermark_path" >
						<b>
							Watermark Path
						</b>
					</Label>
					<Input id="watermark_path" value={watermarkPath} onChange={e => { setWatermarkPath(e.target.value) }} />
				</div>
				<div>
					<Label htmlFor="alpha_value" >
						<b>
							Alpha
						</b>
					</Label>
					<Input id="alpha_value" value={alpha} onChange={e => { setAlpha(e.target.value) }} />
				</div>

			</div>


			<div>
				<Label htmlFor="server_path" >
					<b>
						Server Path
					</b>
				</Label>
				<Input id="server_path" value={serverPath} onChange={e => { setServerPath(e.target.value) }} />
			</div>
			<div className="flex justify-between my-[30px]">
				<Label htmlFor="image_upload">
					<b>
						Upload to server
					</b>
				</Label>
				<Switch id="video_upload" checked={uploadToServer} onCheckedChange={e => { setUploadToServer(e) }} />
			</div>
		</>)
}
