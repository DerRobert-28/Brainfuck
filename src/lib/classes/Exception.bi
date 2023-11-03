'$include:'Exception/CallingSyntaxException.bi'
'$include:'Exception/FileProcessingException.bi'
'$include:'Exception/MacroProcessingException.bi'


function Exception%(handle as integer, message as string)
	Console.writeLine message
	Console.newLine
	error handle
	Exception = handle
end function
