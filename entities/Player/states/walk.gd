extends "common_state.gd"

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	sprite.play(&"walk")


func _physics_process(_delta: float) -> void:
	if player.in_knockback:
		return enter_state(&"Knockback")
	sprite.speed_scale = abs(player.velocity.x / .5)
	if player.can_rotate_sprite:
		find_ground_angle()
	x_movement(_delta)


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	sprite.speed_scale = 1.0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		get_viewport().set_input_as_handled()
		return enter_state(&"Jump")


func x_movement(delta: float) -> void:
	if player.is_on_floor():
		var x_dir: float = Input.get_axis(&"walk_left", &"walk_right")
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
		#!does_input_dir_follow_momentum and abs(player.velocity.x) > player.max_speed/2.0
		if (player.velocity.x > 0 and x_dir < 0 or player.velocity.x < 0 and x_dir > 0) and (abs(player.velocity.x) >= player.max_speed/2.0):
			sprite.play(&"turning")
			player.turnig_particles.process_material.direction.x = -x_dir
			player.turnig_particles.emitting = true
		else:
			if abs(player.velocity.x) >= player.max_speed - 0.5:
				sprite.play(&"running")
			else:
				sprite.play(&"walk")
		# Are we turning?
		# Deciding between acceleration and turn_acceleration
		var accel_rate : float = player.acceleration if does_input_dir_follow_momentum else player.turning_acceleration
		# Accelerate
		player.velocity.x += x_dir * accel_rate * delta
		
		if x_dir == 0.0 and is_zero_approx(player.velocity.x):
				return enter_state(&"Idle")
	else:
		return enter_state(&"Fall")


func find_ground_angle() -> void:
	var floor_normal = player.get_floor_normal()
	visuals.rotation.z = lerp(visuals.rotation.z, -floor_normal.x, .5)
