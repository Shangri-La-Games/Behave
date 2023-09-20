@tool
class_name RangeInput extends HBoxContainer

func _ready() -> void:
	$VBoxContainer/FromSpinBox.value_changed.connect(_on_input_changed)
	$VBoxContainer/ToSpinBox.value_changed.connect(_on_input_changed)

func set_input_label(name: String) -> void:
	$Label.text = name
	
func set_input_range(from: float, to: float) -> void:
	$VBoxContainer/FromSpinBox.value = from
	$VBoxContainer/ToSpinBox.value = to

func _on_input_changed(value: float) -> void:
	get_parent().range_changed(
		$VBoxContainer/FromSpinBox.value,
		$VBoxContainer/ToSpinBox.value
	)
