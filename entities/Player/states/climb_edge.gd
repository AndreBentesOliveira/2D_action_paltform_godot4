extends "common_state.gd"

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	player.velocity = Vector3.ZERO
	player.global_position = _params["land_point"] + Vector3(0.0, 0.0, 0.0)
	player.gripper_area_disable(true)
	return enter_state(&"Walk")


func _physics_process(_delta: float) -> void:
	pass


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	#player.velocity = Vector3.ZERO
	player.gripper_area_disable(false)
