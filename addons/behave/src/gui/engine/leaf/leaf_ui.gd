@tool
class_name LeafUI extends ElementUI

var _function_name: String
var _wait_count: int = 0

var _wait_from: int = 0
var _wait_to: int = 0

func _enter_tree() -> void:
	self.color = BehaveUI.get_color("Leaf")

func set_properties(properties: Dictionary):
	super.set_properties(properties)

	if type == Behave.BehaviorTypeEnum.TASK:
		# Add input field to enter function name
		self._function_name = properties.get("callable", "")
		self.add_text_input("Function Name: ", self._function_name)
	elif type == Behave.BehaviorTypeEnum.WAIT:
		# Add input field to enter wait time
		self._wait_count = properties.get("wait_count", "0")
		self.add_number_input("Count (ms): ", self._wait_count)
	elif type == Behave.BehaviorTypeEnum.WAIT_RAND:
		# Add range field for random wait
		self._wait_from = properties.get("wait_from", "0")
		self._wait_to = properties.get("wait_to", "0")
		self.add_range_input("Range (ms): ", self._wait_from, self._wait_to)
	else:
		self.add_label()

	self.add_input_slot()

func get_properties() -> Dictionary:
	var property =  {"offset": position_offset}
	
	if type == Behave.BehaviorTypeEnum.TASK:
		property["callable"] = self._function_name
	elif type == Behave.BehaviorTypeEnum.WAIT:
		property["wait_count"] = self._wait_count
	elif type == Behave.BehaviorTypeEnum.WAIT_RAND:
		property["wait_from"] = self._wait_from
		property["wait_to"] = self._wait_to
	
	return property

func text_changed(value: String) -> void:
	self._function_name = value

func number_changed(value: float):
	self._wait_count = int(value)

func range_changed(from: float, to: float):
	self._wait_from = from
	self._wait_to = to
