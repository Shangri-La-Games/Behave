class_name Sequence extends Composite

""" 
The sequence node ticks its children sequentially until one of them returns
FAILURE, RUNNING. If all children
return the success state, the sequence also returns SUCCESS.
"""

func tick() -> Behave.StateEnum:
	ticked = true
	
	if status != Behave.StateEnum.RUNNING:
		return status
		
	# When no child is present, assumes SUCCESS
	if children.is_empty():
		return success()
	
	for child in children:
		var result = child.tick()
		if result == Behave.StateEnum.RUNNING:
			return status
		elif result == Behave.StateEnum.FAILURE:
			return failed()
			
	return success()
