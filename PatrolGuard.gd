extends CharacterBody2D

@onready var animationPlayer = $AnimationPlayer
@onready var state = $StateName
const SPEED = 300.0

var _moved_this_frame: bool = false
 
func _ready():
	pass
	#animationPlayer.play("patrol")

	
func setIdle():
	state.frame = 1

func setMove():
	state.frame = 2
	
func setAttack():
	state.frame = 3
		
func setPatrol():
	state.frame = 5
	
func setChase():
	state.frame = 6

func getPos():
	return position

func setRotation(rad):
	rotation = rad
	
func getRotation():
	return rotation
	
func move(p_velocity: Vector2):
	velocity = lerp(velocity, p_velocity, 0.2)	
	
	move_and_slide()
	_moved_this_frame = true
	
	
func rotate_left():
	rotate(deg_to_rad(45))
	
func rotate_right():
	rotate(deg_to_rad(-45))
	
func _physics_process(delta):
	pass
