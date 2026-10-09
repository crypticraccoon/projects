export default function Loading(props: any) {
	//return <div className="absolute top-0 left-0 h-screen w-screen flex justify-center items-center bg-background">
	return <div className={`absolute top-0 left-0 ${props.responsive ? "h-full w-full" : "h-screen w-screen"} flex justify-center items-center bg-background`} >
		<h1> {props.title ? props.title : "loading...."} </h1>
	</div >
}

