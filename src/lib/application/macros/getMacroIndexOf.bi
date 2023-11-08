function getMacroIndexOf%(macroName as string)
	dim as integer	index, macroCount
	dim as string	currentMacro, normalizedName

	normalizedName = String.trim(macroName)
	if String.isEmpty(normalizedName) then
		getMacroIndexOf = -1
		exit function
	endif

	macroCount = ubound(macroNameList)
	for index = 0 to macroCount
		currentMacro = macroNameList(index)
		if Strings.areEqual(currentMacro, normalizedName) then
			getMacroIndexOf = index
			exit function
		endif
	next

	getMacroIndexOf = -1
end function
