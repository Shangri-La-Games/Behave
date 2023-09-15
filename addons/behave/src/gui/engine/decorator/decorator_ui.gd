@tool
class_name DecoratorUI extends ElementUI

var _count: int = 1

func _enter_tree() -> void:
	self.color = BehaveUI.get_color("Decorator")
	
func set_properties(properties: Dictionary):
	super.set_properties(properties)
	self._count = properties.get("count", 1)
	
	if type == Behave.BehaviorTypeEnum.REPEATER:
		self.add_number_input("Count: ", self._count)
	else:
		self.add_label()
	
	self.add_input_output_slot()

func number_changed(value: float):
	self._count = int(value)

func get_properties() -> Dictionary:
	var property =  {"offset": position_offset}
	
	if type == Behave.BehaviorTypeEnum.REPEATER:
		property["count"] = self._count
	
	return property
