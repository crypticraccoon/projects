import { format } from "date-fns"
import { CalendarIcon } from "lucide-react"
import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"
import { Calendar } from "@/components/ui/calendar"
import {
	Popover,
	PopoverContent,
	PopoverTrigger,
} from "@/components/ui/popover"
import { useEffect, useState } from "react";
import { DateModel, } from "@/models/date";
import {
	Tooltip,
	TooltipContent,
	TooltipProvider,
	TooltipTrigger,
} from "@/components/ui/tooltip"
import { UpdateIcon } from "@radix-ui/react-icons"
import { CurretYear } from "@/utils/globals"
import { ImageExtractSheetComponent } from "@/components/custom_ui/sheets/image_sheet"
import { VideoExtractSheetComponent } from "@/components/custom_ui/sheets/video_sheet"
import { ModeToggle } from "../custom_ui/theme/component"

export function Header(props: any) {
	const [dateRange, setDateRange] = useState({ min: CurretYear, max: CurretYear })

	useEffect(() => {
		setDateRange(
			{
				min: (Math.min(...props.calendarDates.map((e: DateModel) => Number(e.year) as number))),
				max: (Math.max(...props.calendarDates.map((e: DateModel) => Number(e.year) as number)))
			}
		)
		props.updateOccupiedDates()
	}, [])

	return (
		<header className="h-[75px] px-[10px] w-screen flex items-center justify-between [&>div>*]:mx-[5px] flex-col md:flex-row [&>div]:py-2">
			<div className="flex flex-row">
				<CalendarComponent {...{ ...props, dateRange }} />
				<RefreshComponent {...{ ...props }} />
			</div>
			<div>
			</div>
			<div className="flex justify-center items-center">
				<ImageExtractSheetComponent />
				<VideoExtractSheetComponent />
				<ModeToggle />
			</div>
		</header>

	)
}

function CalendarComponent(props: any) {
	const [date, setDate] = useState<Date>()

	return (
		<div>
			<Popover>
				<PopoverTrigger asChild>
					<Button
						variant={"outline"}
						className={cn(
							"w-[280px] justify-start text-left font-normal",
							!date && "text-muted-foreground"
						)}
					>
						<CalendarIcon />
						{date ? format(date, "PPP") : <span>Pick a date</span>}
					</Button>
				</PopoverTrigger>
				<PopoverContent className="w-auto p-0">
					<Calendar
						initialFocus
						fromYear={props.dateRange.min}
						toYear={props.dateRange.max}
						mode="single"
						selected={date}
						onSelect={setDate}
						className="rounded-sm border"
						onDayClick={async (day, _, e) => {
							if (e.currentTarget.classList.contains("hasPhotos")) {
								return props.handleSetTargetDate(day)
							}
							props.handleClearTargetDate()
						}}
						modifiers={{
							booked: props.occupiedDates as []
						}}
						modifiersClassNames={{
							booked: "hasPhotos"
						}}
					/>
				</PopoverContent>
			</Popover>
		</div>
	)
}

function RefreshComponent(props: any) {

	async function refreshHeaderData() {
		await props.handleCalendarDates().then(() => {
			props.updateOccupiedDates()
			props.handleClearTargetDate()
			return props.refreshSetTargetDate()
		})
	}
	return (
		<div>
			<TooltipProvider>
				<Tooltip>
					<TooltipTrigger asChild>
						<Button variant="outline" onClick={async () => { await refreshHeaderData() }}>
							<UpdateIcon />
						</Button>
					</TooltipTrigger>
					<TooltipContent>
						<p>Refresh </p>
					</TooltipContent>
				</Tooltip>
			</TooltipProvider>
		</div>
	)
}

