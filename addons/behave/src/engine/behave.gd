class_name Behave

enum StateEnum {
	SUCCESS,
	FAILURE,
	RUNNING,
}

enum BehaviorTypeEnum {
	ROOT,
	INVERTER,
	REPEATER,
	SELECTOR,
	PARALLEL,
	SEQUENCE,
	TASK,
	WAIT,
	MUTE
}

static var behaviors = {}
static func get_behaviors() -> Dictionary:
	if not behaviors.is_empty(): return behaviors
	
	# Decorator
	behaviors[BehaviorTypeEnum.ROOT] = Root
	behaviors[BehaviorTypeEnum.INVERTER] = Inverter
	behaviors[BehaviorTypeEnum.REPEATER] = Repeater
	behaviors[BehaviorTypeEnum.MUTE] = Mute
	
	# Composite
	behaviors[BehaviorTypeEnum.SELECTOR] = Selector
	behaviors[BehaviorTypeEnum.PARALLEL] = Parallel
	behaviors[BehaviorTypeEnum.SEQUENCE] = Sequence
	
	# Leaf
	behaviors[BehaviorTypeEnum.TASK] = Task
	behaviors[BehaviorTypeEnum.WAIT] = Wait
	
	return behaviors
