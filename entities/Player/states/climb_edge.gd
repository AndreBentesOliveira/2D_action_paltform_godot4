extends "common_state.gd"

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	sprite.play(&"edge_climb")
	climb_to_land_position()
	player.head_ray_cast.enabled = false
	player.eyes_ray_cast.enabled = false
	await get_tree().create_timer(0.1).timeout
	player.head_ray_cast.enabled = true
	player.eyes_ray_cast.enabled = true
	player.gripper_area_disable(true)


@warning_ignore("unused_parameter")
func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	player.gripper_area_disable(false)


func climb_to_land_position() -> void:
	var climb_dir = 0
	if sprite.flip_h:
		climb_dir = -0.5
	else:
		climb_dir = 0.5
	var tween = create_tween()
	tween.tween_property(player, "global_position", player.global_position +  Vector3(0.0, 1.0, 0.0), .2)
	tween.tween_property(player, "global_position" ,player.global_position + Vector3(climb_dir, 1.0, 0.0), .2)
	await tween.finished
	return enter_state(&"Fall")
