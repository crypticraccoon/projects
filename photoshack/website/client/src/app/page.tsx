'use client'
import { useEffect, useState } from "react";
import { CalendarModel, DateModel, DayModel, MonthModel } from "@/models/date";
import { ErrorModel } from "@/models/response";
import { GetCalenderData } from "@/api/dates";
import { toast } from "@/hooks/use-toast";
import { ToastAction } from "@/components/ui/toast";
import { Toaster } from "@/components/ui/toaster";
import Loading from "@/components/ui/loading";
import { Toaster as Sonner } from "@/components/ui/sonner"
import { Header } from "@/components/ui/header";
import { TOASTERRORTITLE } from "@/utils/globals";
import { PeriodSection } from "@/components/custom_ui/period/period";
import { InfoSection } from "@/components/custom_ui/info/section";
import HelpComponent from "@/components/custom_ui/help/section";



//Rename Video Sheet to Video Extract Sheet 
export default function Home() {
	const [calendarDates, setCalendarDates] = useState<DateModel[]>()
	const [targetDate, setTargetDate] = useState<DateModel | null>(null)
	const [isLoading, setIsLoading] = useState<boolean>(true)
	const [tempDate, setTempDate] = useState<Date | null>(null)
	const [occupiedDates, setOccupiedDates] = useState<{}>()
	const [serverIp, setServerIp] = useState<string>("")
	const [error, setHasError] = useState(false)

	useEffect(() => {
		(async () => { await handleCalendarDates(); setIsLoading(false) })()
	}, [])

	async function handleSetCalendarDates(data: DateModel[]) {
		setCalendarDates(data)
	}
	function updateOccupiedDates() {
		let selectedDates = []
		let data = calendarDates

		for (let i in data) {
			let year = Number(data[i as any].year)
			for (let o in data[i as any].month) {
				let month = Number(data[i as any].month[o].month) - 1
				for (let u in data[i as any].month[o].day) {
					let day = Number(data[i as any].month[o].day[u].day)
					let nDate = new Date(year, month, day)
					selectedDates.push(nDate)
				}
			}
		}
		setOccupiedDates(selectedDates)
	}

	function handleClearTargetDate() {
		setTargetDate(null)
	}

	function refreshSetTargetDate() {
		if (!calendarDates) { return }
		if (!tempDate) { return }
		let year = calendarDates.filter(year => Number(year.year) === tempDate.getFullYear())
		let month = year[0].month.filter(month => Number(month.month) === tempDate.getMonth() + 1)
		let day = month[0].day.filter(day => Number(day.day) === tempDate.getDate())

		let period = day[0].period.sort((a, b) => parseInt(a.period) - parseInt(b.period))
		let data = {
			year: year[0].year,
			month: [{
				month: month[0].month,
				day: [{
					day: day[0].day,
					period: period
				} as DayModel]
			} as MonthModel]
		}

		setTargetDate(data)
	}


	function handleSetTargetDate(date: Date) {
		if (!calendarDates) { return }
		setTempDate(date)
		let year = calendarDates.filter(year => Number(year.year) === date.getFullYear())
		let month = year[0].month.filter(month => Number(month.month) === date.getMonth() + 1)
		let day = month[0].day.filter(day => Number(day.day) === date.getDate())

		let period = day[0].period.sort((a, b) => parseInt(a.period) - parseInt(b.period))
		let data = {
			year: year[0].year,
			month: [{
				month: month[0].month,
				day: [{
					day: day[0].day,
					period: period
				} as DayModel]
			} as MonthModel]
		}

		setTargetDate(data)
	}
	async function handleCalendarDates() {
		setCalendarDates([])
		let res: CalendarModel | ErrorModel = await GetCalenderData()
		if ((res as ErrorModel).error) {
			toast({
				title: TOASTERRORTITLE,
				description: (res as ErrorModel).error,
				action: <ToastAction altText="Try again" onClick={async () => { await handleCalendarDates() }} >Try again</ToastAction>,
			})
			return
		}
		setCalendarDates((res as CalendarModel).success)
		return
	}
	return (
		<section className="h-full">
			{isLoading ? <Loading /> :
				<>
					<Sonner expand={true} />
					<Toaster  />
					{(calendarDates) ? < Header{...{
						calendarDates,
						occupiedDates,
						updateOccupiedDates,
						handleSetTargetDate,
						refreshSetTargetDate,
						handleCalendarDates,
						handleSetCalendarDates,
						targetDate,
						handleClearTargetDate,
					}} /> : null}
					{targetDate ?
						<PeriodSection
							{...{ targetDate }}
						/> : <InfoSection />}
				</>
			}
			<HelpComponent />
		</section>
	);
}

