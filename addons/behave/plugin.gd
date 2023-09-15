@tool
extends EditorPlugin

var _graph_editor_path: String = "res://addons/behave/src/gui/graph_editor.tscn"

var _scripts: Dictionary = {
	"BehaveUI": "res://addons/behave/src/gui/behave_ui.gd",
	"ElementBuilder": "res://addons/behave/src/gui/engine/element_builder.gd"
}

var _editor: Node
var _graph_editor: GraphEditor
var _graph_editor_init: bool
var _graph_editor_button: Button

var _object_ref: BehaviorTree

func _enter_tree() -> void:
	# Add autoload script (ElementBuilder)
	_load_scripts()
	
	if not ResourceLoader.exists(self._graph_editor_path):
		return

	self._graph_editor_init = true
	if not self._graph_editor:
		self._editor = load(self._graph_editor_path).instantiate()
		self._graph_editor = self._editor.get_node("GraphEdit")

	self._graph_editor_button = add_control_to_bottom_panel(self._editor, "Behavior Editor")
	self._make_visible(false)

func _exit_tree() -> void:
	# Remove autoload scripts
	_remove_scripts()
	
	# Remove GraphEditor panel
	if self._graph_editor_init:
		remove_control_from_bottom_panel(self._editor)
		self._editor.queue_free()
		self._editor = null
		
	self._graph_editor_init = false

func _handles(object: Object) -> bool:
	return (object is BehaviorTree)

func _make_visible(visible: bool) -> void:
	if not visible:
		hide_bottom_panel()

	if self._graph_editor_button:
		self._graph_editor_button.visible = visible

func _edit(object: Object) -> void:
	if not object: return
	
	if object is BehaviorTree:
		self._graph_editor.set_selected_tree(object, self)

func _load_scripts() -> void:
	for key in _scripts.keys():
		if not ResourceLoader.exists(_scripts[key]):
			return
		add_autoload_singleton(key, _scripts[key])

func _remove_scripts() -> void:
	for key in _scripts.keys():
		remove_autoload_singleton(key)
