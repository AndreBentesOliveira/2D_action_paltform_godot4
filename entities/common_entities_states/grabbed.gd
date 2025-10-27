extends "common_entitie_state.gd"

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	pass


func _physics_process(_delta: float) -> void:
	entitie.global_position = entitie.target_gripper.global_position + entitie.texture_ofset_when_grabbed
	sprite.hide()


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	pass
