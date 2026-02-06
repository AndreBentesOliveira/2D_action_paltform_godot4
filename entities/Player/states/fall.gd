extends "jump.gd"

var can_fall_animations : bool

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	can_fall_animations = true
	if _old_state == &"Attack":
		can_fall_animations = false
	can_jump = true
	sprite.play(&"fall")
	if _old_state == &"GrabEdge":
		player.head_ray_cast.enabled = false
		player.eyes_ray_cast.enabled = false
		await get_tree().create_timer(0.2).timeout
		player.head_ray_cast.enabled = true
		player.eyes_ray_cast.enabled = true
	elif _old_state == &"ClimbEdge":
		can_jump = false
	player.gripper_area_disable(false)


func _physics_process(delta: float) -> void:
	super(delta)
	if name == &"Fall":
		if player.velocity.y > 0.0:
			return enter_state(&"Jump")
	if player.velocity.y == 0.0 and player.is_on_floor():
		if player.velocity.x != 0.0:
			return enter_state(&"Walk")
		else:
			return enter_state(&"Idle")
	if player.get_floor_angle() >= 0.80 and not rad_to_deg(player.get_floor_angle()) >= 90.0:
		return enter_state(&"Slide")


@warning_ignore("unused_parameter")
func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	if new_state == &"Jump":
		can_jump = true
	if new_state == "Walk" or  new_state == "Idle" or new_state == "Jump":
		if can_fall_animations:
			player.particle_emitter.emitte("jump_particles")
			knead()


func knead():
	var tween = create_tween()
	tween.tween_property(visuals, "scale", Vector3(1.592, 0.836, 1.0), .1)
	tween.tween_property(visuals, "scale", Vector3(1.0, 1.0, 1.0), .1)
