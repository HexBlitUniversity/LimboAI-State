@tool
extends BTAction

@export var group: StringName
@export var output_var: StringName = &"target"
var index = 0

func _tick(_delta: float) -> Status:
	
	var nodes: Array[Node] = agent.get_tree().get_nodes_in_group(group)
	nodes.reverse()
	var nodeCount = blackboard.get_var(&"nodeCount", 0)
	
	if nodeCount == 0:
		return FAILURE
	
	index = blackboard.get_var(&"index", 0)
	if (index + 1) > (nodeCount - 1):
		index = 0
	else:
		index += 1
	#print("getNextMarker - index: %s" % index)
	
	
	blackboard.set_var(&"index", index)
	blackboard.set_var(output_var, nodes[index])
	
	
	return SUCCESS
	
