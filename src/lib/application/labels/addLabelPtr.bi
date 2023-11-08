sub addLabelPtr(index as integer, labelPtr as unsigned long)
	dim as integer	labelCount
	
	labelCount = ubound(labelPtrList)
	if index > labelCount then redim preserve labelPtrList(index)
	
	labelPtrList(index) = labelPtr
end sub
