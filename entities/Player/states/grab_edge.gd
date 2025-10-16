extends "common_state.gd"


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	player.gripper_area_disable(false)
	player.velocity = Vector3.ZERO
	var offset_y = 0.04
	player.global_position.y -= offset_y
	sprite.play(&"grab_edge")


func _physics_process(_delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		player.can_eledge_grab = false
		return enter_state(&"Jump")
	if event.is_action_pressed(&"down_button"):
		player.can_eledge_grab = false
		return enter_state(&"Fall")

func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	player.gripper_area_disable(true)
