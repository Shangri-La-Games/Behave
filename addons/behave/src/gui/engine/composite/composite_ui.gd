@tool
class_name CompositeUI extends ElementUI

func _enter_tree() -> void:
	self.color = BehaveUI.get_color("Composite")

func _ready() -> void:
	super._ready()
	
	$Slot_0/Add.pressed.connect(self._on_add_node)
	$Slot_0/Remove.pressed.connect(self._on_remove_node)

func set_properties(properties: Dictionary):
	self.add_input_slot()
	
	super.set_properties(properties)
	
func get_properties() -> Dictionary:
	return {
		"offset": position_offset,
		"ports": _count_out_ports()
	}
	
func _on_add_node() -> void:
	self.add_label()
	self.add_output_slot()

func _on_remove_node() -> void:
	if get_child_count() > 1:
		get_parent().remove_slot(name, get_connection_output_count() - 1)
		clear_slot(get_child_count() - 1)
		remove_child(get_child(get_child_count() - 1))

func _count_out_ports() -> int:
	var count = 0
	for child in get_children():
		if child is Label: count += 1
	return count
