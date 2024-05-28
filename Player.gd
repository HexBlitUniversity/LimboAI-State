extends CharacterBody2D

@export var stateName = ""
@onready var camera = $Camera2D 
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var state = $Camera2D/StateName
@onready var axe =  $PlayerRight/Axe

const SPEED = 300.0
var rotate_dir
var health = 10
var hsm: LimboHSM

func _ready():
	_init_state_machine()
	
func _idle_ready():
	animationPlayer.play("idle")
	state.frame = 1	
	
func _move_ready():
	animationPlayer.play("move")
	state.frame = 2

func _attack_ready():
	animationPlayer.play("attack")
	state.frame = 3
	
func _physics_process(delta):
	var direction_y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	rotate_dir = Input.get_action_strength("rotate-right") - Input.get_action_strength("rotate-left")
	var direction = Vector2.DOWN.rotated(rotation) * direction_y 
	velocity = direction * SPEED
	
	if health <= 0 && animationPlayer.current_animation != "dying" && animationPlayer.current_animation != "dead":		
		animationPlayer.play("dying")
		stateName = 9
		return

	

func _idle_physics_process(delta: float):
	if velocity != Vector2.ZERO || rotate_dir != 0:
		hsm.dispatch(&"move_started")
	
func _move_physics_process(delta: float):
	
	rotate((rotate_dir * 8) * delta)
	move_and_slide()
	camera.rotation = -rotation
		
	if velocity == Vector2.ZERO && rotate_dir == 0:
		hsm.dispatch(&"move_ended")

func _attack_physics_process(delta: float):
	if animationPlayer.current_animation != "attack":
		hsm.dispatch(&"state_ended")

func _unhandled_input(event):
	
	# ATTACK STATE
	if event.is_action_released("attack") && axe.visible:
		hsm.dispatch(&"attack_started")
		

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "dying":
		animationPlayer.play("dead")
		state.frame = 10

func _init_state_machine():
	hsm = LimboHSM.new()
	add_child(hsm)
	
	var idle_state = LimboState.new().named("Idle").call_on_enter(_idle_ready).call_on_update(_idle_physics_process)
	var move_state = LimboState.new().named("Move").call_on_enter(_move_ready).call_on_update(_move_physics_process)
	var attack_state = LimboState.new().named("Attack").call_on_enter(_attack_ready).call_on_update(_attack_physics_process)
	
	hsm.add_child(idle_state)
	hsm.add_child(move_state)
	hsm.add_child(attack_state)
	
	hsm.add_transition(idle_state, move_state, &"move_started")
	hsm.add_transition(move_state, idle_state, &"move_ended")
	hsm.add_transition(hsm.ANYSTATE, idle_state, &"state_ended")
	hsm.add_transition(hsm.ANYSTATE, attack_state, &"attack_started")
	
	hsm.initial_state = idle_state
	hsm.initialize(self)
	hsm.set_active(true)
