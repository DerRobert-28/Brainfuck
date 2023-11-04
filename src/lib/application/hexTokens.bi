'BITS	HEX-CODE	COMMAND
'----	--------	-------
'0000	   0		perform no operation
'0001	   1		(ignored)
'0010	   2		goto next cell
'0011	   3		goto previous cell
'0100	   4		increase current cell
'0101	   5		decrease current cell
'0110	   6		output current cell (depending on config)
'0111	   7		input current cell (depending on config)
'1000	   8		begin loop if current cell is not zero
'1001	   9		repeat loop if current cell is not zero
'1010	   A		(ignored)
'1011	   B		return from subroutine
'1100	   C		switch to ascii mode (default; text mode only!)
'1101	   D		switch to number mode (text mode only!)
'1110	   E		switch to text mode (default)
'1111	   F		switch to graphic mode


function HexToken_BeginLoop$()
	HexToken_BeginLoop = "8"
end function


function HexToken_EndLoop$()
	HexToken_EndLoop = "9"
end function


function HexToken_InputCell$()
	HexToken_InputCell = "9"
end function


function HexToken_MinusOne$()
	HexToken_MinusOne = "5"
end function


function HexToken_NextCell$()
	HexToken_NextCell = "2"
end function


function HexToken_NoOperation$()
	HexToken_NoOperation = "0"
end function


function HexToken_OutputCell$()
	HexToken_OutputCell = "6"
end function


function HexToken_PlusOne$()
	HexToken_PlusOne = "4"
end function


function HexToken_PrevCell$()
	HexToken_PrevCell = "7"
end function


function HexToken_Return$()
	HexToken_Return = "B"
end function


function HexToken_Store$(charCode as string)
	dim as string result
	
	result = String.Empty
	if String.contains(HexNumberList, charCode) then result = charCode
	
	HexToken_Store = result
end function


function HexToken_SwitchToAsciiMode$()
	HexToken_SwitchToAsciiMode = "C"
end function


function HexToken_SwitchToGraphMode$()
	HexToken_SwitchToGraphMode = "F"
end function


function HexToken_SwitchToNumberMode$()
	HexToken_SwitchToNumberMode = "D"
end function


function HexToken_SwitchToTextMode$()
	HexToken_SwitchToTextMode = "E"
end function
