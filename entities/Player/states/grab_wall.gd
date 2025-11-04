extends "common_state.gd"

var move_y : float

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	player.velocity = Vector3.ZERO
	#player.star_invencibility()
	player.gripper_area_disable(true)
	player.gripper_area_disable(true)
	sprite.play(&"face_up")


func _physics_process(_delta: float) -> void:
	player.velocity.y = 0.0
	if player.is_on_wall():
		find_wall_angle()
		if Input.is_action_pressed(&"up_button"):
			player.velocity.y += 10.0 * _delta
		elif  Input.is_action_pressed(&"down_button"):
			player.velocity.y -= 10.0 * _delta
		
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
	visuals.rotation.z = -wall_normal.y
