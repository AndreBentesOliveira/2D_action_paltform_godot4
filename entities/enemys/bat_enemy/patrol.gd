extends CommonEnemyState

var dir := true

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	pass


func _physics_process(_delta: float) -> void:
	if enemy_node.is_on_wall():
		dir = !dir
		if dir:
			enemy_node.velocity.x = 5.0 * 1.0 * _delta
		else:
			enemy_node.velocity.x = 5.0 * -1.0 * _delta


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	pass
