@tool
class_name RootUI extends ElementUI

func _enter_tree() -> void:
	self.color = BehaveUI.get_color("Root")
	
func _ready() -> void:
	self.show_close = false

func set_properties(properties: Dictionary):
	self.add_output_slot()
	super.set_properties(properties)
