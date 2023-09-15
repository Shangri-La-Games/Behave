@tool
extends Node

const element_dict: Dictionary = {
	"Root": Behave.ElementTypeEnum.ROOT,
	"Inverter": Behave.ElementTypeEnum.INVERTER,
	"Repeater": Behave.ElementTypeEnum.REPEATER,
	"Selector": Behave.ElementTypeEnum.SELECTOR,
	"Parallel": Behave.ElementTypeEnum.PARALLEL,
	"Sequence": Behave.ElementTypeEnum.SEQUENCE,
	"Task": Behave.ElementTypeEnum.TASK,
	"Wait": Behave.ElementTypeEnum.WAIT
}

const color_dict: Dictionary = {
	"Root": "#FFDF6B",
	"Decorator": "#FA86BE",
	"Composite": "#A275E3",
	"Leaf": "#9AEBED",
}

static func get_color(key: String) -> String:
	return color_dict.get(key, color_dict["Root"])
