Constants:
	const	COMPILATION_ERROR = 1
	const	COMPILED_SUCCESSFULLY = 0
	const	NORMAL_RETURN = -2
	const	NORMAL_TERMINATION = -1
	const	TERMINATED_SUCCESSFULLY = 0
	const	TERMINATED_WITH_ERROR = 1

Globals:
	dim shared as integer IOresult
	dim shared as integer DebugMode

Begin:
	system Main%(command$)

OnException:
	IOresult = err
	resume next

End
