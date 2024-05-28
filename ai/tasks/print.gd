extends BTAction

@export var message = ""

func _tick(_delta: float) -> Status:
	print(message)
	return SUCCESS
