class_name Selector extends Composite

""" 
The priority node (sometimes called selector) ticks its children sequentially 
until one of them returns SUCCESS, RUNNING or FAILURE. 
If all children return the failure state, the priority also returns FAILURE.
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
		elif result == Behave.StateEnum.SUCCESS:
			return success()
			
	return failed()
