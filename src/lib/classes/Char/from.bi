function Char.from$(charCode as integer)
	Char.from = chr$(charCode and 255)
end function
