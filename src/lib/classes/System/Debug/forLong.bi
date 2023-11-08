sub Debug.forLong(message as string, theLong as long)
	dim as string	longStr

	if DebugMode then
		longStr = Long.toString(theLong)
		Console.writeLine String.concat(message, longStr)
	endif
end sub
