class_name Inverter extends Decorator

""" 
The repeater repeats the same node untill RUNNING.
This node ignores FAILED and SUCCESS responses and retick the child instead
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
	
	if result == Behave.StateEnum.SUCCESS:
			return failed()
	
	return success()
