extends "common_state.gd"

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	player.velocity = Vector3.ZERO
	#player.star_invencibility()
	player.gripper_area_disable(true)
	player.gripper_area_disable(true)
	sprite.play(&"face_up")


func _physics_process(_delta: float) -> void:
	player.velocity.z -= 1.0 * _delta
	if player.is_on_wall():
		player.velocity.y += 1.0 * _delta
	else:
		player.velocity.y = 0.0


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	player.gripper_area_disable(false)
	player.gripper_area_disable(false)
