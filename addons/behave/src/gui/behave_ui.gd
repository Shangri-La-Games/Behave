@tool
extends Node

const element_dict: Dictionary = {
	"Root": Behave.BehaviorTypeEnum.ROOT,
	"Inverter": Behave.BehaviorTypeEnum.INVERTER,
	"Repeater": Behave.BehaviorTypeEnum.REPEATER,
	"Selector": Behave.BehaviorTypeEnum.SELECTOR,
	"Parallel": Behave.BehaviorTypeEnum.PARALLEL,
	"Sequence": Behave.BehaviorTypeEnum.SEQUENCE,
	"Task": Behave.BehaviorTypeEnum.TASK,
	"Wait": Behave.BehaviorTypeEnum.WAIT,
	"Mute": Behave.BehaviorTypeEnum.MUTE,
	"WaitRandom": Behave.BehaviorTypeEnum.WAIT_RAND,
}

const color_dict: Dictionary = {
	"Root": "#FFDF6B",
	"Decorator": "#FA86BE",
	"Composite": "#A275E3",
	"Leaf": "#9AEBED",
}

static func get_color(key: String) -> String:
	return color_dict.get(key, color_dict["Root"])
