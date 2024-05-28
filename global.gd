extends Node

class_name Global

enum State {
	UNKNOWN,
	IDLE,
	MOVE,
	ATTACK,
	OPEN,
	PATROL,
	CHASE,
	ASLEEP,
	SURPRISED,
	DYING,
	DEAD
}



static func getState(stateName: String):
	match (stateName):
		"Unknown":
			return State.UNKNOWN
		"Idle":
			return State.IDLE
		"Move":
			return State.MOVE
		"Attack":
			return State.ATTACK
		"Open":
			return State.OPEN
		"Patrol":
			return State.PATROL
		"Chase":
			return State.CHASE
		"Asleep":
			return State.ASLEEP
		"Surprised":
			return State.SURPRISED
		"Dying":
			return State.DYING
		"Dead":
			return State.DEAD

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
