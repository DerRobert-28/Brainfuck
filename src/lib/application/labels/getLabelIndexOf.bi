function getLabelIndexOf%(labelName as string)
	dim as integer	index, labelCount
	dim as string	currentLabel, normalizedName

	normalizedName = String.trim(labelName)
	if String.isEmpty(normalizedName) then
		getLabelIndexOf = -1
		exit function
	endif

	labelCount = ubound(labelNameList)
	for index = 0 to labelCount
		currentLabel = labelNameList(index)
		if Strings.areEqual(currentLabel, normalizedName) then
			getLabelIndexOf = index
			exit function
		endif
	next

	getLabelIndexOf = -1
end function
