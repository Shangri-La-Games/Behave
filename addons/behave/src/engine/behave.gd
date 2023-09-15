class_name Behave

enum StateEnum {
	SUCCESS,
	FAILURE,
	RUNNING,
}

enum ElementTypeEnum {
	ROOT,
	INVERTER,
	REPEATER,
	SELECTOR,
	PARALLEL,
	SEQUENCE,
	TASK,
	WAIT
}

static var elements = {}
static func get_elements() -> Dictionary:
	if not elements.is_empty(): return elements
	
	# Decorator
	elements[ElementTypeEnum.ROOT] = Root
	elements[ElementTypeEnum.INVERTER] = Inverter
	elements[ElementTypeEnum.REPEATER] = Repeater
	
	# Composite
	elements[ElementTypeEnum.SELECTOR] = Selector
	elements[ElementTypeEnum.PARALLEL] = Parallel
	elements[ElementTypeEnum.SEQUENCE] = Sequence
	
	# Leaf
	elements[ElementTypeEnum.TASK] = Task
	elements[ElementTypeEnum.WAIT] = Wait
	
	return elements
