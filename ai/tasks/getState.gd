@tool
extends BTAction

@export var state: Global.State

 
func _tick(_delta: float) -> Status:
	
	if (agent.getState() == state):
		return SUCCESS	
	return FAILURE
