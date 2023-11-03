'$include:'Exception/CallingSyntaxException.bi'
'$include:'Exception/FileProcessingException.bi'
'$include:'Exception/MacroProcessingException.bi'


function Exception%(handle as integer, message as string)
	error handle
	Console.writeLine message
	Console.newLine
	Exception = handle
end function
