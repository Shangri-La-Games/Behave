@tool
class_name TextInput extends HBoxContainer

func _ready() -> void:
	$LineEdit.text_changed.connect(_on_input_changed)

func set_input_label(name: String) -> void:
	$Label.text = name

func set_input_value(value: String) -> void:
	$LineEdit.text = value

func _on_input_changed(value: String) -> void:
	get_parent().text_changed(value)

