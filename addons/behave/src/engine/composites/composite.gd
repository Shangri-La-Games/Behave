class_name Composite extends Behavior

var children: Array[Behavior]

func set_properties(properties: Dictionary, blackboard: Node):
	super.set_properties(properties, blackboard)
	
func tick() -> Behave.StateEnum:
	return Behave.StateEnum.RUNNING
