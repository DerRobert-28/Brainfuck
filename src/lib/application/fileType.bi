function BF_AssemblerFile$(theFile as string)
	BF_AssemblerFile = fileType(theFile, BF_AssemblerFileExtension)
end function

function BF_AssemblerFileExtension$()
	BF_AssemblerFileExtension = "bfa"
end function

function BF_BinaryFile$(theFile as string)
	BF_BinaryFile = fileType(theFile, BF_BinaryFileExtension)
end function

function BF_BinaryFileExtension$()
	BF_BinaryFileExtension = "bfc"
end function

function BF_SourceFile$(theFile as string)
	BF_SourceFile = fileType(theFile, BF_SourceFileExtension)
end function

function BF_SourceFileExtension$()
	BF_SourceFileExtension = "bf"
end function

function fileType$(theFile as string, fileExtension as string)
	fileType = String.concat2(theFile, System.ExtensionSeperator, fileExtension)
end function
