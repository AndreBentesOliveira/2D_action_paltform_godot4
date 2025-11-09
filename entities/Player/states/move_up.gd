extends "common_state.gd"

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	player.can_move_in_z = true
	player.velocity = Vector3.ZERO
	player.star_invencibility()
	player.gripper_area_disable(true)
	player.gripper_area_disable(true)
	sprite.play(&"face_up")


func _physics_process(_delta: float) -> void:
	player.velocity.z -= 1.0 * _delta
	if player.is_on_wall():
		player.velocity.y = 0.0
		if Input.is_action_pressed(&"down_button"):
			player.velocity.y -= 40.0 * _delta
		if Input.is_action_pressed(&"up_button"):
			player.velocity.y += 40.0 * _delta
		#player.velocity.y += 1.0 * _delta
	#else:
		#player.velocity.y = 0.0

func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	player.can_move_in_z = false
	player.gripper_area_disable(false)
	player.gripper_area_disable(false)
