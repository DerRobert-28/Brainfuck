function getLastLabelIndex%()
	dim as integer	labelCount
	dim as string	currentLabel

	labelCount = ubound(labelPtrList)
	currentLabel = labelPtrList(labelCount)

	if String.isNotEmpty(currentLabel) then
		labelCount = labelCount + 1
	endif

	getLastLabelIndex = labelCount
end function
