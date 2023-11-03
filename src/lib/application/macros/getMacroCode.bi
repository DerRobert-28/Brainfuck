function getMacroCode$(index as integer)
	dim as integer	macroCount
	
	if index < 0 then
		getMacroCode = String.Empty
		exit function
	endif

	macroCount = ubound(macroCodeList)
	if index > macroCount then
		getMacroCode = String.Empty
		exit function
	endif

	getMacroCode = macroCodeList(index)
end function
