extends CommonEnemyState

var dir := false

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	print("Enter patrol")


func _physics_process(_delta: float) -> void:
	if enemy_node.is_on_wall() or enemy_node.is_on_ceiling() or enemy_node.is_on_floor():
		dir = !dir
	match enemy_node.move_type_:
		0:
			if dir:
				enemy_node.velocity.x = enemy_node.move_speed * 1.0 * _delta
			else:
				enemy_node.velocity.x = enemy_node.move_speed * -1.0 * _delta
		1:
			if dir:
				enemy_node.velocity.y = enemy_node.move_speed * 1.0 * _delta
			else:
				enemy_node.velocity.y = enemy_node.move_speed * -1.0 * _delta

	if enemy_node.grabbed:
		return enter_state(&"Grabbed")
	if enemy_node.thrown:
		return enter_state(&"Thrown")
	if enemy_node._pushed:
		return enter_state(&"Pushed")

@warning_ignore("unused_parameter")
func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	pass
