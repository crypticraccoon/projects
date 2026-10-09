import Image from "next/image";

export function InfoSection() {
	return (
		<section className="z-[-1] absolute top-0 h-full w-full flex justify-center items-center flex-col text-[#8e8e8e]">
			<b>
				<h1 className="text-[1rem] sm:text-[3vw]">
					Welcome to Rainforest Photoshack!
				</h1>
			</b>
			<Image
				src="/logo.png"
				alt="Logo"
				width={240}
				height={240}
			/>
			<h3 className="text-[0.8rem] sm:text-[1.5vw]">
				<b>
					Please select a <span className="text-primary"> highlighted date</span> to display images.
				</b>
			</h3>
		</section>
	)
}


