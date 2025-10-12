extends "enemy_common_state.gd"


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	sprite.play(&"idle")
