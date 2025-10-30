extends "common_entitie_state.gd"


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	entitie.thrown = true
	entitie.thrown_collider.call_deferred("set","enabled", true)
	entitie.thrown_collider2.call_deferred("set","enabled", true)
	entitie.thrown_collider3.call_deferred("set","enabled", true)
	if entitie.has_node("HitBoxComponent"):
		if entitie.hit_box_component.has_node("CollisionShape3D"):
			entitie.hit_box_component.get_node("CollisionShape3D").call_deferred("set","disabled", true)

func _physics_process(_delta: float) -> void:
	entitie.velocity.x = 60.0 * entitie.thrown_dir * _delta
	sprite.show()
	visuals.rotation_degrees.z += 10.0


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	entitie.thrown = false
