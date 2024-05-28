extends CharacterBody2D

@export var stateName = ""
@onready var camera = $Camera2D 
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var state = $Camera2D/StateName
@onready var axe =  $PlayerRight/Axe

const SPEED = 300.0
var rotate_dir
var health = 10

func _physics_process(delta):
	var direction_y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	rotate_dir = Input.get_action_strength("rotate-right") - Input.get_action_strength("rotate-left")
	var direction = Vector2.DOWN.rotated(rotation) * direction_y 
	velocity = direction * SPEED
	
	if health <= 0 && animationPlayer.current_animation != "dying" && animationPlayer.current_animation != "dead":		
		animationPlayer.play("dying")
		stateName = 9
		return

	if animationPlayer.is_playing() && animationPlayer.current_animation == "attack":
		return

	# IDLE
	if velocity == Vector2.ZERO && rotate_dir == 0:
		animationPlayer.play("idle")
		state.frame = 1		
	
	# MOVEMENT STATE
	if velocity != Vector2.ZERO || rotate_dir != 0:
		animationPlayer.play("move")
		state.frame = 2
		
		rotate((rotate_dir * 8) * delta)
		move_and_slide()
		camera.rotation = -rotation
	
func _unhandled_input(event):
	
	# ATTACK STATE
	if event.is_action_released("attack") && axe.visible:
		animationPlayer.play("attack")
		state.frame = 3



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "dying":
		animationPlayer.play("dead")
		state.frame = 10
