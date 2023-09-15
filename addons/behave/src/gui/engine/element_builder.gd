@tool
extends Node

@onready var root_ui_path: String = "res://addons/behave/src/gui/engine/root/root_ui.tscn"
@onready var composite_ui_path: String = "res://addons/behave/src/gui/engine/composite/composite_ui.tscn"
@onready var decorator_ui_path: String = "res://addons/behave/src/gui/engine/decorator/decorator_ui.tscn"
@onready var leaf_ui_path: String = "res://addons/behave/src/gui/engine/leaf/leaf_ui.tscn"

func get_element_by_node(node) -> ElementUI:
	var element = get_element_ui(node.type)
	element.name = node.name if node.name else "%s"%element.get_instance_id()
	element.set_properties(node.data)
	return element

func get_element_ui(type: int) -> ElementUI:
	match type:
		Behave.BehaviorTypeEnum.INVERTER:
			return self._instantiate_ui(type, decorator_ui_path)
		Behave.BehaviorTypeEnum.REPEATER:
			return self._instantiate_ui(type, decorator_ui_path)
		Behave.BehaviorTypeEnum.SELECTOR:
			return self._instantiate_ui(type, composite_ui_path)
		Behave.BehaviorTypeEnum.PARALLEL:
			return self._instantiate_ui(type, composite_ui_path)
		Behave.BehaviorTypeEnum.SEQUENCE:
			return self._instantiate_ui(type, composite_ui_path)
		_:
			return self._instantiate_ui(type, leaf_ui_path)

func _instantiate_ui(element_id: int, ui_path: String) -> ElementUI:
	assert(ResourceLoader.exists(ui_path))
	
	var element_ui = load(ui_path).instantiate()
	element_ui.type = element_id
	
	return element_ui

