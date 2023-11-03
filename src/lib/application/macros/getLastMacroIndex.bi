function getLastMacroIndex%()
	dim as integer	macroCount
	dim as integer	currentMacro

	macroCount = ubound(macroCodeList)
	currentMacro = macroCodeList(macroCount)

	if String.isNotEmpty(currentMacro) then
		macroCount = macroCount + 1
	endif

	getLastMacroIndex = macroCount
end function
