function String.charAt$(theString as string, index as integer)
	String.charAt = mid$(theString, index + 1, 1)
end function
