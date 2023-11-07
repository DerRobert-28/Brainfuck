function Console.getHeight%()
	dim as integer	newLine, result, yLine

	yLine = Console.getCursorLine
	newLine = yLine

	do
		Try
			newLine = newLine + 1
			Console.setCursorLine newLine
		Catch result
		EndTry

		if result then exit do
	loop

	Console.setCursorLine yLine
	Console.getHeight = newLine
end function


function Console.getWidth%()
	dim as integer	newPos, result, xPos

	xPos = Console.getCursorPos
	newPos = xPos

	do
		Try
			newPos = newPos + 1
			Console.setCursorPos newPos
		Catch result
		EndTry

		if result then exit do
	loop

	Console.setCursorPos xPos
	Console.getWidth = newPos
end function
