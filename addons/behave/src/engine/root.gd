class_name Root extends Decorator

func tick() -> Behave.StateEnum:
	ticked = true
	
	if status != Behave.StateEnum.RUNNING:
		return status
		
	if not child:
		return failed()
		
	return child.tick()
