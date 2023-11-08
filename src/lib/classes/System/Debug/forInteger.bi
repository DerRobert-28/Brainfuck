sub Debug.forInteger(message as string, theInt as integer)
	dim as string	intStr

	if DebugMode then
		intStr = Integer.toString(theInt)
		Console.writeLine String.concat(message, intStr)
	endif
end sub
