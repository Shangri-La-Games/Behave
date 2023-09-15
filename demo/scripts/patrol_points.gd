extends Node3D

var _markers: Array[Marker3D] = []

func _ready() -> void:
	$Node3D.visible = false
	_init_markers()

func _init_markers() -> void:
	for child in get_children():
		if child is Marker3D:
			_markers.append(child)

func set_active_point(node: Node3D) -> void:
	$Node3D.position =  node.global_position
	$Node3D.visible = true

func get_markers() -> Array[Marker3D]:
	return _markers
