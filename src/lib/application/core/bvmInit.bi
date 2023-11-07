sub bvmInit(withVersion as string)
	dim as integer xWidth
	dim as integer yHeight

	xWidth = desktopwidth \ 5
	yHeight = _desktopheight \ 5

	screen newimage(xWidth, yHeight, 256)
	Console.setSize xWidth \ 5, yHeight \ 8
	fullscreen

	bvmGreeting withVersion
end sub
