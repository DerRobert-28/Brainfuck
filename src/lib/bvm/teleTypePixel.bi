sub teleTypePixel(xRef as integer, yRef as integer, colour as integer)
	dim as integer	xPos, xWidth, yHeight, yPos

	xPos = xRef
	xWidth = getWidth
	yPos = yRef
	yHeight = getHeight
	while xPos < 0
		xPos = xPos + xWidth
	wend
	xPos = xPos mod xWidth
	while yPos < 0
		yHeight = yHeight + yHeight
	wend
	yPos = yPos mod yHeight
	pset(xPos, yPos), colour and 255
	
	xPos = (xPos + 1) mod xWidth
	if xPos = 0 then yPos = (yPos + 1) mod yHeight

	xRef = xPos
	yRef = yPos
end sub
