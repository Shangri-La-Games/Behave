class_name Task extends Leaf

var callable: Callable

func set_properties(properties: Dictionary, blackboard: Node):
	super.set_properties(properties, blackboard)
	
	if properties.has("callable"):
		self.callable = Callable(blackboard, properties["callable"])

func tick() -> Behave.StateEnum:
	ticked = true
	
	if status != Behave.StateEnum.RUNNING:
		return status

	if not callable:
		return failed()

	# Call the leaf function
	callable.call(self)

	return status
