extends "common_state.gd"


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	sprite.play(&"jump")
	#player.velocity.y = JUMP_VELOCITY


func _physics_process(_delta: float) -> void:
	player.x_movement(_delta)
	jump_logic(_delta)
	#player.apply_gravity(_delta)
	player.timers(_delta)
	if name == &"Jump":
		#var minimum: float = JUMP_VELOCITY * 0.5
		#if Input.is_action_just_released(&"jump") and player.velocity.y < minimum:
			#player.velocity.y = minimum
		#
		if player.velocity.y <= 0.0:
			return enter_state(&"Fall")


func get_input() -> Dictionary:
	return {
		"just_jump": Input.is_action_just_pressed("jump"),
		"jump": Input.is_action_pressed("jump"),
		"released_jump": Input.is_action_just_released("jump")
	}


func jump_logic(_delta: float) -> void:
	# Reset our jump requirements
	if player.is_on_floor():
		player.jump_coyote_timer = player.jump_coyote
		player.is_jumping = false
	if get_input().just_jump:
		player.jump_buffer_timer = player.jump_buffer

	# Jump if grounded, there is jump input, and we aren't jumping already
	if player.jump_coyote_timer > 0 and player.jump_buffer_timer > 0 and not player.is_jumping:
		player.is_jumping = true
		player.jump_coyote_timer = 0
		player.jump_buffer_timer = 0

		# Compute the jump force based on gravity. Not 100% accurate since we
		# vary gravity at different phases of the jump, but a useful estimate.
		player.velocity.y = sqrt(2 * player.jump_gravity_acceleration * player.jump_height)

	# We're not actually interested in checking if the player is holding the jump button
#	if get_input().jump:pass

	# Cut the velocity if let go of jump. This means our jumpheight is variable
	# This should only happen when moving upwards, as doing this while falling would lead to
	# The ability to stutter our player mid falling
	if get_input().released_jump and player.velocity.y > 0:
		player.velocity.y -= (player.jump_cut * player.velocity.y)

	# This way we won't start slowly descending / floating once we hit a ceiling
	# The value added to the threshold is arbitrary, But it solves a problem
	# where jumping into a ceiling triggers jump_hang_speed_threshold gravity.
	#if player.is_on_ceiling():
		#player.velocity.y = player.jump_hang_speed_threshold
