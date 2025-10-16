extends "common_state.gd"


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	#player.gripper_component.enabled = false
	player.velocity = Vector3.ZERO
	#var offset_y = 0.04
	#player.global_position.y -= offset_y
	sprite.play(&"grab_entitie")


func _physics_process(_delta: float) -> void:
	player.apply_gravity(_delta)
	if not player.is_on_floor():
		player.x_movement(_delta)
	else:
		player.velocity.x = 0
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		#player.grab_entitie = false
		get_viewport().set_input_as_handled()
		return enter_state(&"JumpGrab")
