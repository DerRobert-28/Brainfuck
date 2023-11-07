sub Console.setCursor(xPos as integer, yLine as integer)
	Console.setCursorLine yLine
	Console.setCursorPos xPos
end sub


sub Console.setCursorLine(yLine as integer)
	locate yLine + 1
end sub


sub Console.setCursorPos(xPos as integer)
	locate, xPos + 1
end sub
