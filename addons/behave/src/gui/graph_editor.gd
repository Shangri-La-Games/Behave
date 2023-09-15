@tool
class_name GraphEditor extends GraphEdit

@export var node: Node

@onready var context_menu:ContextMenu = $MarginContainer/VBoxContainer/HBoxContainer/ContextMenu
@onready var save_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/SaveButton
@onready var hint: Label = $MarginContainer/VBoxContainer/Hint

var source = null
var control_node = null

func _ready() -> void:
	_reload()
	
	self.popup_request.connect(self._on_popup_request)
	self.context_menu.get_popup().id_pressed.connect(self._on_menuitem_pressed)
	
	self.connection_request.connect(self._on_connection_request)
	self.disconnection_request.connect(self._on_disconnection_request)
	
	self.save_button.pressed.connect(self._on_save_request)

func _reload():
	if not self.control_node: return
	
	_build_tree_from_source()
	
func _clear():
	for i in get_connection_list():
		disconnect_node(i.from, i.from_port, i.to, i.to_port)
	
	for child in get_children():
		if child is GraphNode: 
			remove_child(child)
			child.queue_free()

func set_selected_tree(root, control) -> void:
	_reload()
	
	if not root: return
	if not control: return
	
	self.source = root
	self.control_node = control
	
	_build_tree_from_source()

func _build_tree_from_source() -> void:
	_clear()
	
	if not self.source: return
	if not self.source.res.tree: return
	if not self.source.res.tree.has("elements"): return
	
	var elements = self.source.res.tree.elements
	var root = self.source.res.tree.root
	var conn = self.source.res.tree.connection
	
	for n in elements:
		add_child(ElementBuilder.get_element_by_node(n))
	
	for c in self.source.res.tree.connection:
		connect_node(c.from, c.from_port, c.to, c.to_port)

var _click_position: Vector2

func _on_popup_request(position: Vector2) -> void:
	self._click_position = get_local_mouse_position()
	
	var popup_menu = context_menu.get_popup()
	var context_position = get_global_mouse_position()
	popup_menu.popup(Rect2(context_position, Vector2(1, 1)))

func _on_menuitem_pressed(id: int) -> void:
	var offset = (self.scroll_offset / self.zoom) + (self._click_position / self.zoom)
	var element_ui = ElementBuilder.get_element_ui(id)
	element_ui.set_properties({"offset": offset})
	
	add_child(element_ui)

func _on_connection_request(from: StringName, from_port: int, to: StringName, to_port: int) -> void:
	if from == to: return
	
	for conn in get_connection_list():
		if from == conn.from and from_port == conn.from_port:
			disconnect_node(conn.from, conn.from_port, conn.to, conn.to_port)
		if to == conn.to and to_port == conn.to_port:
			disconnect_node(conn.from, conn.from_port, conn.to, conn.to_port)
	
	connect_node(from, from_port, to, to_port)

func _on_disconnection_request(from: StringName, from_port: int, to: StringName, to_port: int) -> void:
	disconnect_node(from, from_port, to, to_port)

func _on_save_request():
	if not source: 
		hint.text = "Select a tree first"
		return
	
	hint.text = "Saving tree"
	
	source.res.tree = {
		"elements": []
	}
	
	var info = source.res.tree
	
	for child in get_children():
		if child is GraphNode:
			info.elements.append({
				"name": child.name,
				"type": child.type,
				"data": child.get_properties()
			})
	
	var root = _find_element_by_name(
		info.elements, 
		BehaveUI.element_dict.find_key(Behave.ElementTypeEnum.ROOT)
	)
	_build_tree(root, get_connection_list(), info.elements)
	info.root = root
	info.connection = get_connection_list()
	
	if control_node:
		control_node.get_editor_interface().save_scene()
	
	hint.text = "Tree saved"
	
func _find_element_by_name(elements, name) -> Dictionary:
	for i in elements:
		if i.name == name: return i
	
	return {}
	
func _build_tree(root, connections: Array, elements: Array) -> void:
	var children = []
	var removed = []
	
	for con in connections:
		if con.from == root.name:
			removed.append(con)
	
	root.child = children
	removed.sort_custom(_sort_by_from_port)
	
	for i in removed:
		var child = _find_element_by_name(elements, i.to)
		children.append(child)
		connections.remove_at(connections.find(i))
	
	for i in children:
		_build_tree(i, connections, elements)

func _sort_by_from_port(a, b) -> bool:
	return a.from_port < b.from_port

func remove_slot(name, slot):
	for i in get_connection_list():
		if  i.from == name and i.from_port == slot:
			disconnect_node(i.from, i.from_port, i.to, i.to_port)
	
	return
	
func delete_child(element: GraphNode) -> void:
	for i in get_connection_list():
		if  element.name == i.from:
			disconnect_node(i.from, i.from_port, i.to, i.to_port)
		if  element.name == i.to:
			disconnect_node(i.from, i.from_port, i.to, i.to_port)
	
	element.queue_free()
