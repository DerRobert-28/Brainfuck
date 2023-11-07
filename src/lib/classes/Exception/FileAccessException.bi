function FileAccessException%(message as string)
	FileAccessException = Exception(1003, message)
end function
