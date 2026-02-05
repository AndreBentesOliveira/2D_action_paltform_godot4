extends "common_state.gd"

var land_point : Vector3

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	land_point = _params["wall"].get_node("Marker3D").global_position
	match _params["wall"].platform_type:
		0:
			walk_to_another_area()
		1:
			jump_to_another_area()
		2:
			ladder_to_another_area()

	player.can_move_in_z = true
	player.velocity = Vector3.ZERO
	player.star_invencibility()
	player.gripper_area_disable(true)
	player.gripper_area_disable(true)


func _physics_process(_delta: float) -> void:
	pass

@warning_ignore("unused_parameter")
func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	player.can_move_in_z = false
	player.gripper_area_disable(false)
	player.gripper_area_disable(false)


func jump_to_another_area() -> void:
	var tween = create_tween()
	var tween2 = create_tween()
	tween.tween_property(sprite, "scale", Vector3(0.762, 1.323, 1.0), .1)
	tween.tween_property(sprite, "scale", Vector3(1.0, 1.0, 1.0), .1)
	
	tween2.tween_property(player, "global_position",Vector3(player.global_position.x, land_point.y + .5, land_point.z), .9)
	tween2.tween_property(player, "global_position",Vector3(player.global_position.x, land_point.y, land_point.z), .4)
	await tween2.finished
	return enter_state(&"Idle")


func walk_to_another_area() -> void:
	if land_point.z < player.global_position.z:
		sprite.play(&"walk_backwards")
	else:
		sprite.play(&"walk_foward")
	var tween2 = create_tween()
	tween2.tween_property(player, "global_position",\
	Vector3(player.global_position.x, player.global_position.y, land_point.z), 1.0)
	await tween2.finished
	return enter_state(&"Idle")

func ladder_to_another_area():
	pass
