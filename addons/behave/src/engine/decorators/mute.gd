class_name Mute extends Decorator

""" 
The mute decorator is never return FAILURE.
"""
func tick() -> Behave.StateEnum:
	ticked = true
	
	if status != Behave.StateEnum.RUNNING:
		return status
		
	# When no child is present, assumes SUCCESS
	if not child:
		return success()
		
	var result = child.tick()
	if result == Behave.StateEnum.RUNNING:
			return status
	
	return success()
