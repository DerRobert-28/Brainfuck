function addLabelName%(labelName as string)
	dim as integer	index, labelCount
	dim as string	currentLabel, normalizedName

	normalizedName = String.trim(labelName)
	if String.isEmpty(normalizedName) then
		addLabelName = -1
		exit function
	endif

	labelCount = ubound(labelNameList)
	for index = 0 to labelCount
		currentLabel = labelNameList(index)
		if Strings.areEqual(currentLabel, normalizedName) then
			addLabelName = index
			exit function
		elseif String.isEmpty(currentLabel) then
			labelNameList(index) = normalizedName
			addLabelName = index
			exit function
		endif
	next

	labelCount = labelCount + 1
	redim preserve labelNameList(labelCount)
	labelNameList(labelCount) = normalizedName

	addLabelName = labelCount
end function
