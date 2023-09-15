class_name Repeater extends Decorator

"""
The repeater repeats the same node untill RUNNING.
This node ignores FAILED and SUCCESS responses and retick the child instead
"""

var _count = 0
var _tick_count = 0

func set_properties(properties: Dictionary, blackboard: Node):
	super.set_properties(properties, blackboard)
	self._count = properties.count
	self._tick_count = self._count

func reset() -> Behave.StateEnum:
	super.reset()
	self._tick_count = self._count
	return status

func tick() -> Behave.StateEnum:
	print("Ticking %s :: %s" % [name, status])
	ticked = true
	
	if self._count > 0 and self._tick_count == 0:
		return success()
	
	if status != Behave.StateEnum.RUNNING:
		return status
		
	# When no child is present, assumes SUCCESS
	if not child:
		return success()
	
	if child.status == Behave.StateEnum.SUCCESS:
		child.reset()
	
	var result = child.tick()
	if result == Behave.StateEnum.SUCCESS:
		if self._count > 0:
			self._tick_count -= 1
			
			if self._tick_count == 0:
				success()
			
			return status
	
	if result == Behave.StateEnum.FAILURE:
		return failed()
	
	return status
