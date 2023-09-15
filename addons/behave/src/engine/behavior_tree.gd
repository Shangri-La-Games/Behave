class_name BehaviorTree extends Node

@export var res: BehaveResource
@export var blackboard: Node

@export var debug: bool = false
@export var enable: bool = true

@export_enum("Physics Process", "Process")
var process_type: String = "Process"

var runtime_behavior: Behavior = null

func _enter_tree():
	runtime_behavior = create_behavior_tree(
		res.tree.get("root", {}),
		blackboard,
	)
	
	if not debug: return
	if not runtime_behavior: print("Tree not found %s" % res.tree)
	
func _process(delta: float) -> void:
	if process_type != "Process":
		return
	
	process_tree(delta)

func _physics_process(delta: float) -> void:
	if process_type != "Physics Process":
		return
	
	process_tree(delta)

func process_tree(delta: float):
	if not enable: return
	tick()

func tick():
	if not runtime_behavior: return
	var status = runtime_behavior.tick()

	if status != Behave.StateEnum.RUNNING:
		runtime_behavior.reset()

func create_behavior_tree(behavior: Dictionary, target: Node) -> Behavior:
	if behavior.is_empty():
		return null
	
	var current = Behave.get_behaviors().get(behavior.type).new()
	current.name = behavior.name
	current.set_properties(behavior.data, target)

	for child in behavior.child:
		var child_element = create_behavior_tree(child, target)
		if current is Composite:
			current.children.append(child_element)
		elif current is Decorator:
			current.child = child_element
	
	return current
