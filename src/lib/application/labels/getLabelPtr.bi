function getLabelPtr&&(index as integer)
	dim as integer	labelCount
	
	if index < 0 then
		getLabelPtr = -1
		exit function
	endif

	labelCount = ubound(labelPtrList)
	if index > labelCount then
		getLabelPtr = -1
		exit function
	endif

	getLabelPtr = labelPtrList(index)
end function
