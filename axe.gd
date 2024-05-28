extends StaticBody2D

class_name Axe
@onready var pickUp = $PickUp
@onready var hitBox = $Hitbox

@export var state: AxeState = AxeState.HIDDEN



enum AxeState {
	ON_GROUND,
	EQUIPPED,
	ATTACK,
	HIDDEN,
}
# Called when the node enters the scene tree for the first time.
func _ready():
	monitorCheck()

func _process(delta):
	monitorCheck()
	
	
func monitorCheck():
	match (state):
		0: # ON_GROUND
			visible = true
			pickUp.monitoring = true
			hitBox.monitoring = false		
		1: # EQUIPPED
			visible = true
			pickUp.monitoring = false
			hitBox.monitoring = true			
		2: # Attack
			visible = true
			pickUp.monitoring = false
			hitBox.monitoring = true
		3: # HIDDEN
			visible = false
			pickUp.monitoring = false
			hitBox.monitoring = false
			



func _on_pick_up_body_entered(body):
	if body.is_in_group("isPlayer"):
		body.axe.state = AxeState.EQUIPPED
		queue_free()
		
	
