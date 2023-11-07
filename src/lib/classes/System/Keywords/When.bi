function When%(isTrue as integer, thenValue as integer, elseValue as integer)

	if isTrue then
		When = thenValue
	else
		When = elseValue
	endif

end function

