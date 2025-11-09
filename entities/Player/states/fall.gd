extends "jump.gd"


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	sprite.play(&"fall")
	if _old_state == "GrabEdge":
		
		player.head_ray_cast.enabled = false
		player.eyes_ray_cast.enabled = false
		await get_tree().create_timer(0.2).timeout
		player.head_ray_cast.enabled = true
		player.eyes_ray_cast.enabled = true


func _physics_process(delta: float) -> void:
	super(delta)
	if player.is_on_floor():
		if player.velocity.x != 0.0:
			return enter_state(&"Walk")
		else:
			return enter_state(&"Idle")
