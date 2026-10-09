export interface CalendarModel {
	success: DateModel[]
}

export interface DateModel {
	year: string;
	month: MonthModel[];
}

export interface MonthModel {
	month: string;
	day: DayModel[];
}

export interface DayModel {
	day: string;
	period: PeriodModel[];
}

export interface PeriodModel {
	period: string;
	position: PositionModel[];
}

export interface PositionModel {
	position: string;
	files: string[];
}


