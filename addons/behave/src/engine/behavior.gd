class_name Behavior

var name: String
var status := Behave.StateEnum.RUNNING

var ticked: bool = false

func reset() -> void:
	ticked = false
	status = Behave.StateEnum.RUNNING

func success() -> Behave.StateEnum:
	status = Behave.StateEnum.SUCCESS
	return status

func failed() -> Behave.StateEnum:
	status = Behave.StateEnum.FAILURE
	return status

func set_properties(properties: Dictionary, blackboard: Node):
	pass

func tick() -> Behave.StateEnum:
	return Behave.StateEnum.RUNNING
