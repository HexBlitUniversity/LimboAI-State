extends CharacterBody2D

@onready var stateName = $StateName
@onready var animationPlayer = $AnimationPlayer
@onready var vision = $Vision
@onready var bodyGroup = $bodyGroup

@export var hsm: LimboHSM
@export var idle_state: BTState 
@export var sleep_state: BTState
@export var surprised_state: BTState
@export var chase_state: BTState
@export var attack_state: BTState
@export var dying_state: BTState
@export var dead_state: BTState

@export var state_var: StringName = &"state"
@export var axe_is_visible_var: StringName = &"axe_is_visible"

var _moved_this_frame: bool = false
var _frames_since_facing_update: int = 0
const SPEED = 300.0

func _ready():
	_init_state_machine()
	hsm.dispatch(&"begin_sleep")

	
func _physics_process(_delta):
	if hsm.get_active_state().blackboard.has_var(state_var):
		var stateVar: int = hsm.get_active_state().blackboard.get_var(state_var, 0)
		if stateName.frame != stateVar:
			stateName.frame = stateVar
			
func move(p_velocity: Vector2) -> void:
	velocity = lerp(velocity, p_velocity, 0.2)
	move_and_slide()
	_moved_this_frame = true	
	
## Returns 1.0 when agent is facing right.
## Returns -1.0 when agent is facing left.
func get_facing() -> float:
	return signf(scale.x)

func look(dir: Vector2):
	print("Look %s " % dir)
	look_at(dir)
## Face specified direction.
func face_dir(dir: Vector2) -> void:
	
	print("Look at %s " % dir)
	look_at(dir)
	_frames_since_facing_update = 0
	#if dir > 0.0 and scale.x < 0.0:
	#	scale.x = 1.0;
	
	#if dir < 0.0 and scale.x > 0.0:
		#scale.x = -1.0;
		#_frames_since_facing_update = 0

## Update agent's facing in the velocity direction.
func update_facing() -> void:
	_frames_since_facing_update += 1
	if _frames_since_facing_update > 3:
		face_dir(velocity)

func _on_vision_body_exited(body):
	print(" %s has exited." % body)
	
func _on_vision_body_entered(body):
	print(" %s has entered." % body)
	if hsm.get_active_state() == sleep_state:
		if body.is_in_group("isPlayer"):
			begin_surprised()
	
	

func _init_state_machine():
	
	idle_state.named("Guard_Idle")
	sleep_state.named("Guard_Asleep")
	surprised_state.named("Guard_Surprised")
	chase_state.named("Guard_Chase")
	attack_state.named("Guard_Attack")
	dying_state.named("Guard_Dying")
	dead_state.named("Guard_Dead")
	
	hsm.add_transition(hsm.ANYSTATE, idle_state, &"begin_idle")
	hsm.add_transition(hsm.ANYSTATE, sleep_state, &"begin_sleep")
	hsm.add_transition(sleep_state, surprised_state, &"begin_surprised")
	hsm.add_transition(hsm.ANYSTATE, chase_state, &"begin_chase")
	hsm.add_transition(hsm.ANYSTATE, attack_state, &"begin_attack")
	hsm.add_transition(hsm.ANYSTATE, dying_state, &"begin_death")
	hsm.add_transition(dying_state, dead_state, &"is_dead")
	
	hsm.initialize(self)
	hsm.set_active(true)

	
func getState():
	var stateName: String = "Unknown"
	if hsm != null && hsm.get_active_state() != null && hsm.get_active_state().name != null:
		stateName = hsm.get_active_state().name
	var en_state = Global.getState(stateName)
	print(en_state)
	return en_state
	

func begin_idle():
	hsm.dispatch(&"begin_idle")

func begin_sleep():
	hsm.dispatch(&"begin_sleep")
	
func begin_surprised():
	hsm.dispatch(&"begin_surprised")
	
func begin_chase():
	hsm.dispatch(&"begin_chase")
	
func begin_attack():
	hsm.dispatch(&"begin_attack")

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"surprised":
			hsm.dispatch(&"begin_chase")
		"dying":
			hsm.dispatch(&"is_dead")
			


func _on_hurtbox_body_entered(body):
	print("_on_hurtbox_body_entered")
	if body.is_in_group("axe"):
		print("body.is_in_group(\"axe\")")
		var axe = body as Axe
		# We only want it to affect enemies when player attacks
		if axe.state == Axe.AxeState.ATTACK:
			print("axe in hitbox")
			hsm.dispatch("begin_death")
