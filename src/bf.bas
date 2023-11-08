'$include:'bf.bi'


function Main%(cmdLine as string)
	dim as string	fileName
	dim as integer	result
	dim as string	resultStr
	dim as integer	inFile
	dim as string	byteCodeStream
	dim as string	byteCode
	dim as string	hexCode
	dim as string	NormalReturn
	dim as string	NormalTermination

	Debug.disable
	bvmInit With(VERSION)

	fileName = String.trim(cmdLine)
	if String.isEmpty(fileName) then
		Main = Throw(CallingSyntaxException("Calling syntax: bf <file>"))
		exit function
	endif

	Try
		inFile = File.open(BF_BinaryFile(fileName), FileMode.ForReading)
	Catch result
	EndTry

	if result then
		Main = Throw(FileAccessException("Could not access file."))
		exit function
	endif
	
	byteCodeStream = String.Empty
	do until File.endOf(inFile)
		byteCode = File.read(inFile, 1)
		hexCode = dec2hex(Char.codeAt(byteCode, 0), 2)
		String.prepend byteCodeStream, hexCode
	loop
	File.close inFile
	byteCodeStream = String.reverse(byteCodeStream)

	result = executeCode(byteCodeStream, 0)
	resultStr = Integer.toString(result)
	NormalReturn = Integer.toString(NORMAL_RETURN)
	NormalTermination = Integer.toString(NORMAL_TERMINATION)

	if Console.getCursorPos then Console.newLine
	Console.newLine
	Console.writeLine String.concat("Programme terminated with code: ", resultStr)
	Console.writeLine String.concat2("> code '", NormalReturn, "' means 'normal return'")
	Console.writeLine String.concat2("> code '", NormalTermination, "' means 'normal termination'")
	Console.newLine
	Console.newLine
	'Console.setCursor 0, Console.getHeight - 1
	Console.writeLine "Hit any key to quit ..."
	Invokes Console.read(1)
	
	Main = When(Either(result = NORMAL_RETURN, result = NORMAL_TERMINATION),	_
		TERMINATED_SUCCESSFULLY,						_
		TERMINATED_WITH_ERROR)
end function
