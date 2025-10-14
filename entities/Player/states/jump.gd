extends "common_state.gd"

var eledge_grab := false
var entitie_grab : = false

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	eledge_grab = false
	entitie_grab = false
	if _old_state == "GrabEntitie":
		entitie_grab = true
	if _old_state == "GrabEdge":
		eledge_grab = true
		player.head_ray_cast.enabled = false
		player.eyes_ray_cast.enabled = false
		await get_tree().create_timer(0.1).timeout
		player.head_ray_cast.enabled = true
		player.eyes_ray_cast.enabled = true
	sprite.play(&"jump")


func _physics_process(_delta: float) -> void:
	player.x_movement(_delta)
	player.apply_gravity(_delta)
	check_for_ledge()
	jump_logic(_delta)
	if player.can_eledge_grab:
		return enter_state(&"GrabEdge")
	if player.grab_entitie:
		return enter_state(&"GrabEntitie")
	#if already_jump:
		#if player.is_on_floor():
			#return enter_state(&"TrowEntitie")
	if name == &"Jump":
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
	if (player.jump_coyote_timer > 0 and player.jump_buffer_timer > 0 and not player.is_jumping) or (entitie_grab or eledge_grab):
		player.is_jumping = true
		player.jump_coyote_timer = 0
		player.jump_buffer_timer = 0
		eledge_grab = false
		entitie_grab = false
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

func check_for_ledge():
	player.can_eledge_grab = not player.head_ray_cast.is_colliding() and player.eyes_ray_cast.is_colliding()
