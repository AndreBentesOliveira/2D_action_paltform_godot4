extends "common_state.gd"

var jump_grab_entitie := false

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	jump_grab_entitie = false
	player.gripper_component.enabled = false
	player.velocity = Vector3.ZERO
	var offset_y = 0.04
	player.global_position.y -= offset_y
	sprite.play(&"grab_entitie")


func _physics_process(_delta: float) -> void:
	if not player.is_on_floor():
		player.x_movement(_delta)
	else:
		player.velocity.x = 0
	jump_logic(_delta)
	#if jump_grab_entitie:
		#print("jump_grab_entitie")
		#if player.is_on_floor() or get_input().jump:
			#player.grab_entitie = false
			#player.gripper_component.enabled = true
			#return enter_state(&"TrowEntitie")


func _unhandled_input(event: InputEvent) -> void:
	pass


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
		jump_grab_entitie = true

	# We're not actually interested in checking if the player is holding the jump button
#	if get_input().jump:pass

	# Cut the velocity if let go of jump. This means our jumpheight is variable
	# This should only happen when moving upwards, as doing this while falling would lead to
	# The ability to stutter our player mid falling
	if get_input().released_jump and player.velocity.y > 0:
		player.velocity.y -= (player.jump_cut * player.velocity.y)
