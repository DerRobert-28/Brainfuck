sub EndTry()
	shared as integer IOresult
	on error goto 0
	IOresult = 0
end sub


sub Try()
	shared as integer IOresult
	IOresult = 0
	on error goto OnException
end sub
