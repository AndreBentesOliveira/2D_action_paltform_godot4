extends "common_state.gd"


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	sprite.play(&"walk")


func _physics_process(_delta: float) -> void:
	x_movement(_delta)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		get_viewport().set_input_as_handled()
		return enter_state(&"Jump")
	if event.is_action_pressed(&"crouch"):
		get_viewport().set_input_as_handled()
		return enter_state(&"Crouch")


func x_movement(delta: float) -> void:
	if player.is_on_floor():
		var x_dir: float = Input.get_axis(&"walk_left", &"walk_right")
		print(x_dir)
		if x_dir != 0.0:
			sprite.flip_h = x_dir < 0.0
		# Brake if we're not doing movement inputs.
		if x_dir == 0:
			player.velocity.x = Vector2(player.velocity.x, 0).move_toward(Vector2.ZERO, player.deceleration * delta).x

		var does_input_dir_follow_momentum = sign(player.velocity.x) == x_dir
		# If we are doing movement inputs and above max speed, don't accelerate nor decelerate
		# Except if we are turning
		# (This keeps our momentum gained from outside or slopes)
		if abs(player.velocity.x) >= player.max_speed and does_input_dir_follow_momentum:
			return
		# Are we turning?
		# Deciding between acceleration and turn_acceleration
		var accel_rate : float = player.acceleration if does_input_dir_follow_momentum else player.turning_acceleration
		# Accelerate
		player.velocity.x += x_dir * accel_rate * delta
		
		if x_dir == 0.0 and is_zero_approx(player.velocity.x):
				return enter_state(&"Idle")
	else:
		return enter_state(&"Fall")
