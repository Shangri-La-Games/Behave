extends CharacterBody3D

@export var movement_speed: float = 4.0

@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")
@onready var patrol_points = get_parent().get_node("PatrolPoints")

var target_position: Vector3 = Vector3.ZERO

# ================================================================
func task_find_target(task: Task) -> void:
	var points: Array[Marker3D] = patrol_points.get_markers()
	var next_point = points.pick_random()
	patrol_points.set_active_point(next_point)
	
	target_position = next_point.global_position
	print("NEXT_POINT >> ", target_position)
	navigation_agent.set_target_position(target_position)
	
	task.success()

func move_to_target(task: Task) -> void:
	if navigation_agent.is_navigation_finished():
		return
	
	var current_position: Vector3 = global_position
	self._set_lookat_direction(current_position, target_position)
	velocity = (target_position - current_position).normalized() * movement_speed
	move_and_slide()
	
	if navigation_agent.is_target_reached():
		print("TARGET_REACHED")
		task.success()

func _set_lookat_direction(current: Vector3, target: Vector3):
	var lookat_position = target
	lookat_position.y = current.y
	
	if not global_transform.origin.is_equal_approx(lookat_position):
		look_at(lookat_position)
