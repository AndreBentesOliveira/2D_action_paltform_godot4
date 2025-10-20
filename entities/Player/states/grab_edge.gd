extends "common_state.gd"


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	
	var edge  = player.head_ray_cast.get_collision_point() - player.eyes_ray_cast.get_collision_point()
	print(edge)
	player.gripper_area_disable(true)
	player.velocity = Vector3.ZERO
	var offset_y = 0.04
	#var offset_x = 0.04
	#if sprite.flip_h:
		#player.global_position.x -= offset_x
	#else:
		#player.global_position.x += offset_x
#
	player.global_position.y -= offset_y
	sprite.play(&"grab_edge")


func _physics_process(_delta: float) -> void:
	var wall_point = player.get_node("RayCast1").get_collision_point()
	var wall_normal = player.get_node("RayCast1").get_collision_normal()
	player.get_node("RayCast2").global_position = wall_point - (wall_normal * 0.1) + Vector3(0, 0.3, 0)
	player.get_node("RayCast2").force_raycast_update()
	if player.get_node("RayCast2").is_colliding():
		var floor_normal = player.get_node("RayCast2").get_collision_normal()
		if floor_normal.is_equal_approx(Vector3.UP):
			var ledge_point = player.get_node("RayCast2").get_collision_point()
		
			var edge_position = ledge_point + (wall_normal * player.ledge_grab_offset.x) + (Vector3.UP * player.ledge_grab_offset.y)
			player.global_position = edge_position


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		player.can_eledge_grab = false
		return enter_state(&"Jump")
	if event.is_action_pressed(&"down_button"):
		player.can_eledge_grab = false
		return enter_state(&"Fall")

func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	player.gripper_area_disable(false)
