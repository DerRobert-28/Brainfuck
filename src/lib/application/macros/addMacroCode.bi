sub addMacroCode(index as integer, macroCode as string)
	dim as integer	macroCount
	dim as string	normalizedCode
	
	normalizedCode = String.trim(macroCode)
	if String.isEmpty(normalizedCode) then exit sub
	
	macroCount = ubound(macroCodeList)
	if index > macroCount then redim preserve macroCodeList(index)
	
	macroCodeList(index) = normalizedCode
end sub
