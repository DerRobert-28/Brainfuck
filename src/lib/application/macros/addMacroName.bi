function addMacroName%(macroName as string)
	dim as integer	index, macroCount
	dim as string	currentMacro, normalizedName

	normalizedName = String.trim(macroName)
	if String.isEmpty(normalizedName) then
		addMacroName = -1
		exit function
	endif

	macroCount = ubound(macroNameList)
	for index = 0 to macroCount
		currentMacro = macroNameList(index)
		if Strings.areEqual(currentMacro, normalizedName) then
			addMacroName = index
			exit function
		elseif String.isEmpty(currentMacro) then
			macroNameList(index) = normalizedName
			addMacroName = index
			exit function
		endif
	next

	macroCount = macroCount + 1
	redim preserve macroNameList(macroCount)
	macroNameList(macroCount) = normalizedName

	addMacroName = macroCount
end function
