extends CommonEnemyState



func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	enemy_node.get_node("CollisionShape3D").call_deferred("set","disabled", true)
	return_to_patrol()

func _physics_process(_delta: float) -> void:
	pass


@warning_ignore("unused_parameter")
func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	pass


func return_to_patrol() -> void:
	print(enemy_node.init_position)
	var tween = create_tween()
	tween.tween_property(enemy_node, "global_position", enemy_node.init_position, .5)
	await  tween.finished
	enemy_node.get_node("CollisionShape3D").call_deferred("set","disabled", false)
	return enter_state(&"Patrol")
