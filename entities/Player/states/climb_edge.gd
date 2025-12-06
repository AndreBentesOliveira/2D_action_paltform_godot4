extends "common_state.gd"

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	#player.velocity = Vector3.ZERO
	player.global_position = _params["land_point"] + Vector3(0.0, 0.0, 0.0)
	player.head_ray_cast.enabled = false
	player.eyes_ray_cast.enabled = false
	await get_tree().create_timer(0.1).timeout
	player.head_ray_cast.enabled = true
	player.eyes_ray_cast.enabled = true
	player.gripper_area_disable(true)


func _physics_process(_delta: float) -> void:
	return enter_state(&"Fall")


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	#pass
	#player.velocity = Vector3.ZERO
	player.gripper_area_disable(false)
