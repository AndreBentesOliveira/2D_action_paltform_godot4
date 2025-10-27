extends "common_entitie_state.gd"


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	entitie.thrown_collider.call_deferred("set","enabled", true)
	entitie.thrown_collider2.call_deferred("set","enabled", true)
	entitie.thrown_collider3.call_deferred("set","enabled", true)
	#if not direction:
		#thrown_dir = 1
	#else:
		#thrown_dir = -1
	#thrown_collider.target_position.x *= thrown_dir
	#thrown_collider2.target_position.x *= thrown_dir
	#thrown_collider3.target_position.x *= thrown_dir


func _physics_process(_delta: float) -> void:
	entitie.velocity.x = 60.0 * entitie.thrown_dir * _delta
	sprite.show()
	visuals.rotation_degrees.z += 10.0


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	pass
