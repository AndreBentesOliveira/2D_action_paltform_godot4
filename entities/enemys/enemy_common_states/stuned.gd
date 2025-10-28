extends "enemy_common_state.gd"


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	enemy_node.velocity = Vector3.ZERO
	#sprite.play(&"stun")


func _physics_process(_delta: float) -> void:
	pass


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	pass
