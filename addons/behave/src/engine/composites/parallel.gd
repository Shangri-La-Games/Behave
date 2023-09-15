class_name Parallel extends Composite

""" 
The parallel node ticks all children at the same time, 
allowing them to work in parallel.
"""

func tick() -> Behave.StateEnum:
	print("Ticking %s :: %s" % [name, status])
	ticked = true
	
	if status != Behave.StateEnum.RUNNING:
		return status
		
	# When no child is present, assumes SUCCESS
	if children.is_empty():
		return success()
	
	var child_count = 0
	for child in children:
		var result = child.status
		
		if result == Behave.StateEnum.RUNNING:
			result = child.tick()
			
		if result == Behave.StateEnum.SUCCESS:
			child_count += 1
		
		if result == Behave.StateEnum.FAILURE:
			return failed()
			
	if child_count == children.size():
		success()
		
	return status
