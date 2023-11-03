sub String.prepend(stringByRef as string, content as string)
	stringByRef = String.concat(content, stringByRef)
end sub
