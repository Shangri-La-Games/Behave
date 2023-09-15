@tool
class_name ContextMenu extends MenuButton

@onready var popup = get_popup()

func _ready():
	popup.clear()
	for key in BehaveUI.element_dict.keys():
		popup.add_item(key, BehaveUI.element_dict[key])
