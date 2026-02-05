extends "common_entitie_state.gd"


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	entitie.velocity = Vector3.ZERO
	sprite.play(&"idle")


func _physics_process(_delta: float) -> void:
	if entitie.grabbed:
		return enter_state(&"Grabbed")
	if entitie.thrown:
		return enter_state(&"Thrown")
	if entitie._pushed:
		return enter_state(&"Pushed")

@warning_ignore("unused_parameter")
func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	entitie.thrown = false
	entitie.grabbed = false
	entitie._pushed = false
