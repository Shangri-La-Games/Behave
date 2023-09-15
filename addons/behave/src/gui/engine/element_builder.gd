@tool
extends Node

@onready var root_ui_path: String = "res://addons/behave/src/gui/engine/root/root_ui.tscn"
@onready var composite_ui_path: String = "res://addons/behave/src/gui/engine/composite/composite_ui.tscn"
@onready var decorator_ui_path: String = "res://addons/behave/src/gui/engine/decorator/decorator_ui.tscn"
@onready var leaf_ui_path: String = "res://addons/behave/src/gui/engine/leaf/leaf_ui.tscn"

func _add_input_slot(element: ElementUI) -> Node:
	var child = Control.new()
	element.add_child(child)

	# Define slot for this child
	var index_of_child = element.get_child_count() - 1
	element.set_slot(
		index_of_child,
		true, 0, Color.BLUE,
		false, 0, Color.BLUE,
		null, null
	)
	return element

func _add_output_slot(element: ElementUI) -> Node:
	var child = Control.new()
	element.add_child(child)

	# Define slot for this child 
	var index_of_child = element.get_child_count() - 1
	element.set_slot(
		index_of_child,
		false, 0, Color.BLUE,
		true, 0, Color.BLUE,
		null, null
	)
	return element

func _root_ui(element: ElementUI) -> ElementUI:
	_add_output_slot(element)
	return element

func _decorator_ui(element: ElementUI) -> ElementUI:
	_add_input_slot(element)
	_add_output_slot(element)
	return element

func _composites_ui(element: ElementUI) -> ElementUI:
	_add_input_slot(element)
	_add_output_slot(element)
	return element

func _leaf_ui(element: ElementUI) -> ElementUI:
	_add_input_slot(element)
	return element

func get_element_by_node(node) -> ElementUI:
	var element = get_element_ui(node.type)
	element.set_properties(node.data)
	return element

func get_element_ui(element_id: int) -> ElementUI:
	match element_id:
		Behave.ElementTypeEnum.ROOT:
			return self._instantiate_ui(element_id, root_ui_path)
		Behave.ElementTypeEnum.INVERTER:
			return self._instantiate_ui(element_id, decorator_ui_path)
		Behave.ElementTypeEnum.REPEATER:
			return self._instantiate_ui(element_id, decorator_ui_path)
		Behave.ElementTypeEnum.SELECTOR:
			return self._instantiate_ui(element_id, composite_ui_path)
		Behave.ElementTypeEnum.PARALLEL:
			return self._instantiate_ui(element_id, composite_ui_path)
		Behave.ElementTypeEnum.SEQUENCE:
			return self._instantiate_ui(element_id, composite_ui_path)
		_:
			return self._instantiate_ui(element_id, leaf_ui_path)

func _instantiate_ui(element_id: int, ui_path: String) -> ElementUI:
	assert(ResourceLoader.exists(ui_path))
	
	var element_ui = load(ui_path).instantiate()
	element_ui.type = element_id
	element_ui.name = BehaveUI.element_dict.find_key(element_id)
	
	return element_ui

