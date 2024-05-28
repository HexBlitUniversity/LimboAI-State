extends LimboState
@onready var player = $Player
@onready var hsm: LimboHSM = $"../LimboHSM"
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var state = $Camera2D/StateName

# Called when the node enters the scene tree for the first time.
func _enter():
	if animationPlayer != null:
		animationPlayer.play("idle")
		state.frame = 1		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _update(delta):
	if player.velocity != Vector2.ZERO || player.rotate_dir != 0:
		hsm.dispatch(&"move_started")
