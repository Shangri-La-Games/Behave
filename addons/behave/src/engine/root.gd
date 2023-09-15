class_name Root extends Decorator

func tick() -> Behave.StateEnum:
#	print("Ticking %s :: %s" % [name, status])
	ticked = true
	
	if status != Behave.StateEnum.RUNNING:
		return status
		
	if not child:
		return failed()
		
	return child.tick()
