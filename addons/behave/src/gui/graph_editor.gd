@tool
class_name GraphEditor extends GraphEdit

@export var node: Node

@onready var hint: Label = get_parent().get_node("Footer/Hint")
@onready var save_button: Button = get_parent().get_node("Header/SaveButton")
@onready var context_menu:ContextMenu = get_parent().get_node("Header/ContextMenu")

var source = null
var control_node = null

func _ready() -> void:
	self.popup_request.connect(self._on_popup_request)
	self.context_menu.popup.id_pressed.connect(self._on_menuitem_pressed)
	
	self.connection_request.connect(self._on_connection_request)
	self.disconnection_request.connect(self._on_disconnection_request)
	
	self.save_button.pressed.connect(self._on_save_request)

func _clear():
	for conn in get_connection_list():
		disconnect_node(conn.from, conn.from_port, conn.to, conn.to_port)
	
	for child in get_children():
		if child is GraphNode: 
			if child.type != Behave.BehaviorTypeEnum.ROOT:
				remove_child(child)
				child.queue_free()

func set_selected_tree(root, control) -> void:
	_clear()
	
	if not root: return
	if not control: return
	
	self.source = root.res
	self.control_node = control
	
	_build_tree_from_source()

func _build_tree_from_source() -> void:
	if not self.source: return
	if not self.source.tree: return
	if not self.source.tree.has("elements"): return

	var root = self.source.tree.root
	var elements = self.source.tree.elements
	var connections = self.source.tree.connection

	for element in elements:
		# Root element is added by default
		if element.type == Behave.BehaviorTypeEnum.ROOT:
			var node = get_node("Root")
			node.set_properties(element.data)
		else:
			add_child(ElementBuilder.get_element_by_node(element))

	for conn in connections:
		connect_node(conn.from, conn.from_port, conn.to, conn.to_port)

var _click_position: Vector2
func _on_popup_request(position: Vector2) -> void:
	self._click_position = get_local_mouse_position()
	
	var context_position = get_global_mouse_position()
	context_menu.popup.popup(Rect2(context_position, Vector2(1, 1)))

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
	
	source.tree = {
		"elements": []
	}
	
	var info = source.tree
	
	for child in get_children():
		if child is ElementUI:
			info.elements.append({
				"name": child.name,
				"type": child.type,
				"data": child.get_properties()
			})
	
	var root = _find_element_by_name(info.elements, "Root")
	_build_tree(root, get_connection_list(), info.elements)
	
	info.root = root
	info.connection = get_connection_list()
	
	if control_node:
		control_node.get_editor_interface().save_scene()
	
	hint.text = "Tree saved"
	
func _find_element_by_name(elements, name) -> Dictionary:
	for element in elements:
		if element.name == name: 
			return element
	
	return {}
	
func _build_tree(root, connections: Array, elements: Array) -> void:
	var children = []
	var removed = []
	
	for conn in connections:
		if conn.from == root.name:
			removed.append(conn)
	
	root.child = children
	removed.sort_custom(_sort_by_from_port)
	
	for conn in removed:
		var child = _find_element_by_name(elements, conn.to)
		children.append(child)
		connections.remove_at(connections.find(conn))
	
	for child in children:
		_build_tree(child, connections, elements)

func _sort_by_from_port(a, b) -> bool:
	return a.from_port < b.from_port

func remove_slot(name, slot):
	for conn in get_connection_list():
		if  conn.from == name and conn.from_port == slot:
			disconnect_node(conn.from, conn.from_port, conn.to, conn.to_port)

func delete_child(element: GraphNode) -> void:
	for conn in get_connection_list():
		if  element.name == conn.from:
			disconnect_node(conn.from, conn.from_port, conn.to, conn.to_port)
		
		if  element.name == conn.to:
			disconnect_node(conn.from, conn.from_port, conn.to, conn.to_port)
	
	element.queue_free()
