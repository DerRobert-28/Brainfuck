function dec2hex$(decimalNumber as integer, count as integer)
	dim as string result, zeros
	if count < 1 then
		dec2hex = hex$(decimalNumber)
	else
		zeros = String.repeat("0", count)
		result = String.concat(zeros, hex$(decimalNumber))
		result = String.reverse(result)
		result = String.subStr(result, 0, count)
		dec2hex = String.reverse(result)
	endif
end function

function hex2dec%(hexNumber as string)
	hex2Dec = val(String.concat("&H0", String.trim(hexNumber)))
end function
