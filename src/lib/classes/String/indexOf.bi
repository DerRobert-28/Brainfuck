function String.indexOf%(theString as string, search as string)
	if String.isEmpty(theString) or String.isEmpty(search) then
		String.indexOf = -1
	else
		String.indexOf = instr(1, theString, search) - 1
	endif
end function
