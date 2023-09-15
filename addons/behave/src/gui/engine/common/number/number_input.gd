@tool
class_name NumberInput extends HBoxContainer

func _ready() -> void:
	$SpinBox.value_changed.connect(_on_input_changed)

func set_input_label(name: String) -> void:
	$Label.text = name
	
func set_input_value(value: float) -> void:
	$SpinBox.value = value

func _on_input_changed(value: float) -> void:
	get_parent().number_changed(value)
