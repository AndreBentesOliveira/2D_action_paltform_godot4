extends "common_state.gd"

var land_point: Vector3

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	if player.move_plat_detect.is_colliding():
		player.move_plat_detect.get_collider().get_parent().attach_player(player)
	player.gripper_area_disable(true)
	player.velocity = Vector3.ZERO
	sprite.play(&"grab_edge")
	

func _physics_process(_delta: float) -> void:
	if player.in_knockback:
		return enter_state(&"Knockback")
	var wall_point = player.get_node("RayCast1").get_collision_point()
	var wall_normal = player.get_node("RayCast1").get_collision_normal()
	player.get_node("RayCast2").global_position = wall_point - (wall_normal * 0.1) + Vector3(0, .5, 0)
	player.get_node("RayCast2").force_raycast_update()
	if player.get_node("RayCast2").is_colliding():
		var floor_normal = player.get_node("RayCast2").get_collision_normal()
		if floor_normal.is_equal_approx(Vector3.UP):
			var ledge_point = player.get_node("RayCast2").get_collision_point()
			var edge_position = ledge_point + (wall_normal * player.ledge_grab_offset.x) + (Vector3.UP * player.ledge_grab_offset.y)
			visuals.global_position = edge_position
			player.get_node("Debug").global_position = ledge_point
			land_point = ledge_point
			print(player.global_position)
			print(land_point)
	var distance_to_land_point = player.global_position - land_point
	if (distance_to_land_point.x > 1 and distance_to_land_point.x > 0) or\
		(distance_to_land_point.x < -1 and distance_to_land_point.x < 0):
		land_point = player.global_position
			#print("visual global positio: " + str(visuals.global_position))
			#print("edge_position global positio: " + str(edge_position))
	if player.get_node("RayCast2").position.x < 0.0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump") or event.is_action_pressed(&"up_button"):
		player.can_eledge_grab = false
		return enter_state(&"ClimbEdge", {"land_point" : land_point})
	if event.is_action_pressed(&"down_button"):
		player.can_eledge_grab = false
		return enter_state(&"Fall")


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	if player.move_plat_detect.is_colliding():
		player.move_plat_detect.get_collider().get_parent().desattach_player()
	visuals.position = Vector3.ZERO
	#player.head_ray_cast.position.y = 0.11
	player.gripper_area_disable(false)
