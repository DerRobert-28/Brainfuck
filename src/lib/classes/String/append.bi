sub String.append(stringByRef as string, content as string)
	stringByRef = String.concat(stringByRef, content)
end sub

sub String.append2(stringByRef as string, first as string, second as string)
	stringByRef = String.concat2(stringByRef, first, second)
end sub
