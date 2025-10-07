extends "jump.gd"


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	if _old_state == "GrabEdge":
		player.can_check_for_ledge = false
	else:
		player.can_check_for_ledge = true
	sprite.play(&"fall")


func _physics_process(delta: float) -> void:
	super(delta)
	
	if player.is_on_floor():
		if player.velocity.x != 0.0:
			return enter_state(&"Walk")
		else:
			return enter_state(&"Idle")
