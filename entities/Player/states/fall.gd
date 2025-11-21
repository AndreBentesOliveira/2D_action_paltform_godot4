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


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	player.jump_particles.emitting = true
	if new_state == "Walk" or  new_state == "Idle":
		knead()


func knead():
	var tween = create_tween()
	tween.tween_property(visuals, "scale", Vector3(1.592, 0.836, 1.0), .1)
	tween.tween_property(visuals, "scale", Vector3(1.0, 1.0, 1.0), .1)
