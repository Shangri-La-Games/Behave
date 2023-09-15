class_name Wait extends Leaf

var _count = 0
var _tick_count = 0

"""
The wait leaf pause an action for certain time.
"""
func set_properties(properties: Dictionary, blackboard: Node):
	super.set_properties(properties, blackboard)
	
	self._count = properties.wait_count
	self._tick_count = self._count

func reset() -> void:
	super.reset()
	
	self._tick_count = self._count
	
func tick() -> Behave.StateEnum:
	ticked = true
	
	if _tick_count <= 0:
		return success()
		
	if status != Behave.StateEnum.RUNNING:
		return status

	self._tick_count -= Engine.time_scale
	
	if self._tick_count <= 0:
		success()
		
	return status
