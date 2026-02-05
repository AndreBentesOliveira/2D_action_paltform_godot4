extends "common_state.gd"

var eledge_grab = false
var climb_speed := 70.0
var visual_offset := 0.235
var leave_floor := false
var leave_floor_timer : float = 0.0

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	leave_floor_timer = 0.0
	leave_floor = false
	if _old_state == "Jump" and player.is_on_floor():
		leave_floor = true
	eledge_grab = false
	if _old_state == "GrabEdge":
		eledge_grab = true
		player.head_ray_cast.enabled = false
		player.eyes_ray_cast.enabled = false
		await get_tree().create_timer(0.1).timeout
		player.head_ray_cast.enabled = true
		player.eyes_ray_cast.enabled = true
	player.velocity = Vector3.ZERO
	player.gripper_area_disable(true)
	player.gripper_area_disable(true)
	sprite.play(&"wall_grab")


func _physics_process(_delta: float) -> void:
	leave_floor_timer += _delta
	if leave_floor_timer > 0.5:
		leave_floor = false
	if !sprite.flip_h:
		visuals.position.x = -visual_offset 
	else:
		visuals.position.x = visual_offset
	check_for_ledge()
	if player.can_eledge_grab:
		return enter_state(&"GrabEdge")
	if not leave_floor:
		if player.is_on_floor():
			return enter_state(&"Idle")
	if player.in_knockback:
		return enter_state(&"Knockback")
	player.velocity.y = 0.0
	if Input.is_action_pressed(&"down_button"):
		sprite.play(&"wall_slide")
		player.velocity.y -= climb_speed * _delta
	#if player.is_on_wall() and player.get_node("DetectWall").is_colliding():
	elif Input.is_action_pressed(&"up_button"):
		sprite.play(&"wall_climb")
		player.velocity.y += climb_speed * _delta
	else:
		sprite.play(&"wall_grab")


@warning_ignore("unused_parameter")
func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	visuals.position = Vector3.ZERO
	player.gripper_area_disable(false)
	player.gripper_area_disable(false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		return enter_state(&"Jump")


func check_for_ledge() -> void:
	player.can_eledge_grab = not player.head_ray_cast.is_colliding() and player.eyes_ray_cast.is_colliding()
