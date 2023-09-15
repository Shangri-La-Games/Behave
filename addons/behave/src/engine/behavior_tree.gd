class_name BehaviorTree extends Node

@export var res: BehaveResource
@export var blackboard: Node

@export var debug: bool = false
@export var enable: bool = true

@export_enum("Physics Process", "Process")
var process_type: String = "Process"

var behavior: Behavior = null

func _enter_tree():
	behavior = create_tree(
		res.tree.get("root", {}),
		blackboard,
	)
	
	if not debug: return
	if not behavior: print("Tree not found %s" % res.tree)
	if behavior: print("Entering tree '%s'" % behavior.name)
	
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
	if not behavior: return
	var status = behavior.tick()

	if status !=  Behave.StateEnum.RUNNING:
		behavior.reset()

func create_tree(element: Dictionary, target: Node) -> Behavior:
	if element.is_empty():
		return null

	var current = Behave.get_elements().get(element.type).new()
	current.name = element.name
	current.set_properties(element.data, target)

	for child in element.child:
		var child_element = create_tree(child, target)
		if current is Composite:
			current.children.append(child_element)
		elif current is Decorator:
			current.child = child_element
	
	return current
