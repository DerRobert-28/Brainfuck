Globals:
	dim shared as integer IOresult
Begin:
	system Main%(command$)
OnException:
	IOresult = err
	resume next
End
