extends "common_state.gd"

var land_point : Vector3

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	land_point = _params["wall"].get_node("Marker3D").global_position
	jump_to_another_area()
	print(land_point)
	player.can_move_in_z = true
	player.velocity = Vector3.ZERO
	player.star_invencibility()
	player.gripper_area_disable(true)
	player.gripper_area_disable(true)
	sprite.play(&"move_up")


func _physics_process(_delta: float) -> void:
	pass

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
