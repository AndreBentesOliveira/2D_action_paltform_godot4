extends "common_state.gd"

var move_y : float
var eledge_grab = false
func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	eledge_grab = false
	if _old_state == "GrabEdge":
		eledge_grab = true
		player.head_ray_cast.enabled = false
		player.eyes_ray_cast.enabled = false
		await get_tree().create_timer(0.1).timeout
		player.head_ray_cast.enabled = true
		player.eyes_ray_cast.enabled = true
	player.velocity = Vector3.ZERO
	#player.star_invencibility()
	player.gripper_area_disable(true)
	player.gripper_area_disable(true)
	sprite.play(&"face_up")


func _physics_process(_delta: float) -> void:
	find_wall_angle()
	print(player.can_eledge_grab)
	if player.can_eledge_grab:
		return enter_state(&"GrabEdge")
	if player.is_on_floor():
		return enter_state(&"Idle")
	#if player.in_knockback:
		#return enter_state(&"Knockback")
	player.velocity.y = 0.0
	if Input.is_action_pressed(&"down_button"):
			player.velocity.y -= 70.0 * _delta
	if player.is_on_wall() and player.get_node("DetectWall").is_colliding():
		if Input.is_action_pressed(&"up_button"):
			player.velocity.y += 70.0 * _delta
		
		#player.velocity.y += 10.0 * _delta
	#else:
		#player.velocity.y = 0.0


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	player.gripper_area_disable(false)
	player.gripper_area_disable(false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		return enter_state(&"Jump")


func find_wall_angle():
	var wall_normal = player.get_wall_normal()
	visuals.rotation.z = wall_normal.y
