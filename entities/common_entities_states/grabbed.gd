extends "common_entitie_state.gd"

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	sprite.hide()


func _physics_process(_delta: float) -> void:
	if entitie.thrown:
		return enter_state(&"Thrown")


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	entitie.grabbed = false
