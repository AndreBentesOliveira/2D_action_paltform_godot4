extends "common_state.gd"


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	sprite.play(&"grab_edge")
	player.is_hanging_on_ledge = true


func _physics_process(_delta: float) -> void:
	player.velocity = Vector3.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		player.is_hanging_on_ledge = false
		return enter_state(&"Jump")
	if event.is_action_pressed(&"crouch"):
		player.is_hanging_on_ledge = false
		return enter_state(&"Fall")
