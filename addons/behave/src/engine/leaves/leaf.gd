class_name Leaf extends Behavior

func set_properties(properties: Dictionary, blackboard: Node):
	super.set_properties(properties, blackboard)
	
func tick() -> Behave.StateEnum:
	return Behave.StateEnum.RUNNING
