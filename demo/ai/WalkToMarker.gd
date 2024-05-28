extends BTAction

@export var output_var: StringName = &"target"
@export var speed_var: StringName = &"speed"

## How long to perform this task (in seconds).
@export var duration: float = 0.1

func _tick(_delta: float) -> Status:
	var node = blackboard.get_var(output_var)

	#print("WalkToMarker - node: %s" % node)
	var speed: float = 100.0 #blackboard.get_var(speed_var, 100.0)
	var desired_velocity: Vector2 = Vector2.ZERO
	
	
		
	if int(int(agent.getPos().x > node.position.x) ):		
		#print("agent.pos.x: %s > node.x: %s" % [int(agent.getPos().x), int(node.position.x)])
		if agent.getRotation() == deg_to_rad(180):
			agent.setRotation(0)
		desired_velocity = Vector2.LEFT * speed
		
	if int(int(agent.getPos().x < node.position.x) ):		
		#print("agent.pos.x: %s < node.x: %s" % [int(agent.getPos().x), int(node.position.x)])
		if agent.getRotation() == 0:
			agent.setRotation(deg_to_rad(180))
		desired_velocity = Vector2.RIGHT * speed
		
	if desired_velocity != Vector2.ZERO:
		agent.setPatrol()
		#print("velocity: %s" % desired_velocity)
		agent.move(desired_velocity)
		if elapsed_time > duration:
			return SUCCESS
		return RUNNING
		

	return FAILURE
