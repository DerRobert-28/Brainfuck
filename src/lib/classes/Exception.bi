'$include:'Exception/CallingSyntaxException.bi'
'$include:'Exception/CompilerException.bi'
'$include:'Exception/FileAccessException.bi'
'$include:'Exception/FileProcessingException.bi'
'$include:'Exception/MacroProcessingException.bi'
'$include:'Exception/NumberProcessingException.bi'


function Exception%(handle as integer, message as string)
	Console.writeLine message
	Console.newLine
	error handle
	Exception = handle
end function
