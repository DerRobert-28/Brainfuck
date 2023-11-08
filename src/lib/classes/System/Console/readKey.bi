function Console.readKey$
	dim as string	readKey

	do
		readKey = inkey$
	loop while String.isEmpty(readKey)

	Console.readKey = readKey
end function
