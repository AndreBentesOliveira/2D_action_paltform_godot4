extends "common_state.gd"

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	sprite.play(&"edge_climb")
	var tween = create_tween()
	tween.tween_property(player, "global_position", player.global_position +  Vector3(0.0, 1.0, 0.0), .2)
	tween.tween_property(player, "global_position" ,_params["land_point"], .2)
	player.head_ray_cast.enabled = false
	player.eyes_ray_cast.enabled = false
	await get_tree().create_timer(0.1).timeout
	player.head_ray_cast.enabled = true
	player.eyes_ray_cast.enabled = true
	player.gripper_area_disable(true)


func _physics_process(_delta: float) -> void:
	pass
	#return enter_state(&"Fall")


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	player.gripper_area_disable(false)


func _on_sprite_3d_animation_finished() -> void:
	return enter_state(&"Fall")
