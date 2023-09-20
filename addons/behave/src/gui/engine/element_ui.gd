@tool
class_name ElementUI extends GraphNode

@export var color: String = BehaveUI.get_color("ROOT")

var number_input = preload("res://addons/behave/src/gui/engine/common/number/number_input.tscn")
var text_input = preload("res://addons/behave/src/gui/engine/common/text/text_input.tscn")

var type: Behave.BehaviorTypeEnum

func _ready():
	self.show_close = true
	self.comment = true
	
	self.close_request.connect(_on_close_request)

func set_properties(properties: Dictionary):
	self.position_offset = properties.offset
	self.title = BehaveUI.element_dict.find_key(self.type)
	
	if not properties.has("ports"): return
	for i in range(properties.ports):
		self.add_label()
		self.add_output_slot()

func get_properties() -> Dictionary:
	return {"offset": position_offset}

func add_input_slot() -> void:
	set_slot(
		get_child_count() - 1,
		true, 0, Color(self.color),
		false, 0, Color(self.color),
		null, null
	)

func add_label(show_count = true) -> void:
	var label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

	if show_count:
		label.text = str(get_child_count())
	
	self.add_child(label)

func add_number_input(label: String, value: float) -> void:
	var input: NumberInput = number_input.instantiate()
	input.set_input_label(label)
	input.set_input_value(value)
	
	self.add_child(input)
	

func add_text_input(label: String, value: String) -> void:
	var input: TextInput = text_input.instantiate()
	input.set_input_label(label)
	input.set_input_value(value)
	
	self.add_child(input)
	
func add_output_slot() -> void:
	set_slot(
		get_child_count() - 1, 
		false, 0, Color(self.color),
		true, 0, Color(self.color),
		null, null
	)

func add_input_output_slot() -> void:
	set_slot(
		get_child_count() - 1, 
		true, 0, Color(self.color),
		true, 0, Color(self.color),
		null, null
	)

func _on_close_request():
	get_parent().delete_child(self)
