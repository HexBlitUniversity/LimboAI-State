@tool
extends BTAction

@export var group: StringName
@export var output_var: StringName = &"target"

var index = 0

func _tick(_delta: float) -> Status:
	var nodes: Array[Node] = agent.get_tree().get_nodes_in_group(group)
	nodes.reverse()
	blackboard.set_var(&"nodeCount", nodes.size())
	
	if nodes.size() == 0:
		return FAILURE
		
	blackboard.set_var(&"index", 0)
	blackboard.set_var(output_var, nodes[0])
	
	print("GetPatrolNodes - Index: %s" % index)
	print("GetPatrolNodes - node: %s" % nodes[0])
	return SUCCESS
