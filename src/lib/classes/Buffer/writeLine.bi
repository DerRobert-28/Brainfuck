sub Buffer.writeLine(bufferByRef as string, content as string)
	String.append2 bufferByRef, Char.NewLine, content
end sub
