import { URL } from "@/utils/globals"
import { CalendarModel } from "@/models/date"
import { ErrorModel } from "@/models/response"
import { APICALLFAILED } from "@/utils/errors"

export async function GetCalenderData() {
	try {
		let res = await fetch(`${URL}/calendar`)
		if (res.status !== 200) {
			return await res.json() as ErrorModel
		}
		let data: CalendarModel = await res.json()
		return data

	} catch (e: any) {
		return { error: APICALLFAILED } as ErrorModel
	}
}

