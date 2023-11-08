function Console.getCursorLine%()
	Console.getCursorLine = csrlin - 1
end function


function Console.getCursorPos%()
	Console.getCursorPos = pos(0) - 1
end function
