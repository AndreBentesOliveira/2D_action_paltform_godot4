extends "common_state.gd"


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	sprite.play(&"idle")


func _physics_process(_delta: float) -> void:
	player.gripper_area_disable(true)
	if player.get_floor_angle() >= 0.80 and player.can_rotate_sprite:
		return enter_state(&"Slide")
	if player.in_knockback:
		return enter_state(&"Knockback")
	player.velocity = Vector3.ZERO
	if player.is_on_floor():
		if Input.get_axis(&"walk_left", &"walk_right") != 0.0:
			return enter_state(&"Walk")
	else:
		return enter_state(&"Fall")
	if Input.is_action_pressed(&"up_button") and player.face_up_raycast.is_colliding():
		sprite.play(&"face_up")
	elif Input.is_action_pressed(&"down_button") and player.face_down_raycast.is_colliding():
		sprite.play(&"face_down")
	else:
		sprite.play(&"idle")
	if Input.is_action_pressed(&"up_button") and Input.is_action_pressed(&"action_button") and player.face_up_raycast.is_colliding():
		return enter_state(&"MoveUp", {"wall" : player.face_up_raycast.get_collider()})
	elif Input.is_action_pressed(&"down_button") and Input.is_action_pressed(&"action_button") and player.face_down_raycast.is_colliding():
		return enter_state(&"MoveUp", {"wall" : player.face_down_raycast.get_collider()})


@warning_ignore("unused_parameter")
func _exit_state(old_state: StringName, state_data: Dictionary) -> void:
	player.gripper_area_disable(false)


func _unhandled_input(event: InputEvent) -> void:
	if player.get_input().down_button and player.get_floor_angle() >= 0.42:
		return enter_state(&"Slide")
	if event.is_action_pressed(&"jump"):
		return enter_state(&"Jump")
	if event.is_action_pressed(&"attack") and not player.is_attacking:
		return enter_state(&"Attack")


func rotate_to_angle(angulo_alvo_graus: Vector3, duracao: float) -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "rotation_degrees", angulo_alvo_graus, duracao)#\
	await tween.finished
