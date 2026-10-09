
import {
	Tooltip,
	TooltipContent,
	TooltipProvider,
	TooltipTrigger,
} from "@/components/ui/tooltip"

import {
	Dialog,
	DialogContent,
	DialogDescription,
	DialogHeader,
	DialogTitle,
	DialogTrigger,
} from "@/components/ui/dialog"

import {
	Accordion,
	AccordionContent,
	AccordionItem,
	AccordionTrigger,
} from "@/components/ui/accordion"
import { QuestionMarkIcon } from "@radix-ui/react-icons"

export default function HelpComponent() {
	return (
		<div className="fixed bottom-0 right-0">
			<TooltipProvider>
				<Tooltip>
					<TooltipTrigger>
						<Dialog>
							<DialogTrigger>
								<div className="m-[25px] p-[15px] cursor-pointer duration-500 transition hover:bg-background hover:text-foreground bg-primary text-background ease-in rounded-md">
									<QuestionMarkIcon />
								</div>
							</DialogTrigger>
							<DialogContent>
								<DialogHeader>
									<DialogTitle>Help Menu</DialogTitle>
									<DialogDescription>
										<Accordion type="single" collapsible>
											<AccordionItem value="item-1">
												<AccordionTrigger>How to access site on another computer?</AccordionTrigger>
												<AccordionContent>
													1). Connect to the same <b className="text-primary">wifi network</b>
													<br />
													2). Open to browser
													<br />
													3). Navigate to <b><a href="http://192.168.1.239" target="_blank" className="text-primary">http://192.168.1.239</a>
													</b>


												</AccordionContent>
											</AccordionItem>

											<AccordionItem value="item-2">
												<AccordionTrigger>Where are files saved on the computer?</AccordionTrigger>
												<AccordionContent>

													All files can be found on the Desktop, in folder <b className="text-primary">photoshack</b>.


												</AccordionContent>
											</AccordionItem>


										</Accordion>
									</DialogDescription>
								</DialogHeader>
							</DialogContent>
						</Dialog>

					</TooltipTrigger>
					<TooltipContent>
						Help
					</TooltipContent>
				</Tooltip>
			</TooltipProvider>
		</div>
	)
}
