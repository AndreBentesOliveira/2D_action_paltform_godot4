extends "common_state.gd"

var move_y : float
var eledge_grab = false
var wall_direction: Vector3

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
	check_for_ledge()
	find_wall_angle()
	#if !sprite.flip_h:
		#player.velocity.x += 1.0 * _delta
	#else:
		#player.velocity.x += -.5 * _delta
	if player.can_eledge_grab:
		return enter_state(&"GrabEdge")
	if player.is_on_floor():
		return enter_state(&"Idle")
	#if player.in_knockback:
		#return enter_state(&"Knockback")
	player.velocity.y = 0.0
	if Input.is_action_pressed(&"down_button"):
			player.velocity.y -= 40.0 * _delta
	if player.is_on_wall() and player.get_node("DetectWall").is_colliding():
		if Input.is_action_pressed(&"up_button"):
			player.velocity.y += 40.0 * _delta
		
		#player.velocity.y += 10.0 * _delta
	#else:
		#player.velocity.y = 0.0


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	player.gripper_area_disable(false)
	player.gripper_area_disable(false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		return enter_state(&"Jump")


func find_wall_angle() -> void:
	var wall_normal = player.get_wall_normal()
	visuals.rotation.z = wall_normal.y
	#wall_direction = Vector3.UP.cross(wall_normal).normalized()
	#print(wall_direction, wall_normal)

func check_for_ledge() -> void:
	player.can_eledge_grab = not player.head_ray_cast.is_colliding() and player.eyes_ray_cast.is_colliding()
