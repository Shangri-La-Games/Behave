@tool
class_name LeafUI extends ElementUI

var _function_name: String
var _wait_count: int = 0

func _enter_tree() -> void:
	self.color = BehaveUI.get_color("Leaf")

func set_properties(properties: Dictionary):
	super.set_properties(properties)

	if type == Behave.ElementTypeEnum.TASK:
		# Add input field to enter function name
		self._function_name = properties.get("callable", "")
		self.add_text_input("Function Name: ", self._function_name)
	elif type == Behave.ElementTypeEnum.WAIT:
		# Add input field to enter wait time
		self._wait_count = properties.get("wait_count", "0")
		self.add_number_input("Count (ms): ", self._wait_count)
	else:
		self.add_label()

	self.add_input_slot()

func get_properties() -> Dictionary:
	var property =  {"offset": position_offset}
	
	if type == Behave.ElementTypeEnum.TASK:
		property["callable"] = self._function_name
	elif type == Behave.ElementTypeEnum.WAIT:
		property["wait_count"] = self._wait_count
	
	return property

func text_changed(value: String) -> void:
	self._function_name = value

func number_changed(value: float):
	self._wait_count = int(value)
