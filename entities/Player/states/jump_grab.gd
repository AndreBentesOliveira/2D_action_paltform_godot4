extends "common_state.gd"

var jump_cont := 0
var air_jump := true
var normal_gravity : float
var normal_jump_gravity : float

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	normal_gravity = player.gravity_acceleration
	normal_jump_gravity = player.jump_gravity_acceleration
	player.gravity_acceleration = 1.0
	player.jump_gravity_acceleration = 2.0
	jump_cont = 0
	air_jump = true


func _physics_process(_delta: float) -> void:
	if not player.is_on_floor():
		player.x_movement(_delta)
	else:
		player.velocity.x = 0.0
	player.apply_gravity(_delta)
	jump_logic(_delta)
	
	if get_input().just_jump:
		print("PRESS JUMP")
		jump_cont += 1
		print(jump_cont)
	if player.velocity.y <= 0.0 and player.is_on_floor():
		print("bateu no chao")
		jump_cont += 1
		print(jump_cont)
	if jump_cont == 2:
		jump_cont = 0
		return enter_state(&"TrowEntitie")


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	player.gravity_acceleration = normal_gravity
	player.jump_gravity_acceleration = normal_jump_gravity

func get_input() -> Dictionary:
	return {
		"just_jump": Input.is_action_just_pressed("jump"),
		"jump": Input.is_action_pressed("jump"),
		"released_jump": Input.is_action_just_released("jump")
	}


func jump_logic(_delta: float) -> void:
	# Reset our jump requirements
	if player.is_on_floor() or air_jump:
		player.jump_coyote_timer = player.jump_coyote
		player.is_jumping = false
		air_jump = false
		
	if get_input().just_jump:
		player.jump_buffer_timer = player.jump_buffer

	if (player.jump_coyote_timer > 0 and player.jump_buffer_timer > 0 and not player.is_jumping):
		player.is_jumping = true
		player.jump_coyote_timer = 0
		player.jump_buffer_timer = 0
		player.velocity.y = sqrt(2 * player.jump_gravity_acceleration * player.jump_height)

	if get_input().released_jump and player.velocity.y > 0:
		player.velocity.y -= (player.jump_cut * player.velocity.y)

	#if player.is_on_ceiling():
		#player.velocity.y = player.jump_hang_speed_threshold
