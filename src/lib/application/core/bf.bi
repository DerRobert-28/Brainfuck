Constants:
	const	COMPILED_SUCCESSFULLY = 0
	const	NORMAL_RETURN = -8
	const	NORMAL_TERMINATION = -1

Globals:
	dim shared as integer IOresult

Begin:
	system Main%(command$)

OnException:
	IOresult = err
	resume next

End
