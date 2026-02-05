extends "enemy_common_state.gd"

var check_is_on_floor := false

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	check_is_on_floor = false
	sprite.play(&"hurt")
	enemy_node.velocity = Vector3.ZERO
	push()
	stretch()
	await get_tree().create_timer(.1).timeout
	check_is_on_floor = true


func _physics_process(_delta: float) -> void:
	sprite.rotation_degrees.z += 1000.0 * _delta
	if (check_is_on_floor and enemy_node.is_on_floor()) or enemy_node.is_on_wall():
		return enter_state(&"Stuned")
	if enemy_node.grabbed:
		return enter_state(&"Grabbed")


@warning_ignore("unused_parameter")
func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	knead()
	sprite.play(&"idle")
	enemy_node._pushed = false
	sprite.rotation.z = 0.0


func push():
	var tween = create_tween()
	tween.tween_property(enemy_node, "velocity", enemy_node._pushed_dir * 2.5, .1)
	tween.tween_property(enemy_node, "velocity", Vector3(enemy_node._pushed_dir.x * 2.5, -1.0, 0.0), .3)


func stretch():
	var tween = create_tween()
	tween.tween_property(visuals, "scale", Vector3(0.600, 1.500, 1.0), .1)
	tween.tween_property(visuals, "scale", Vector3(1.0, 1.0, 1.0), .1)


func knead():
	var tween = create_tween()
	tween.tween_property(visuals, "scale", Vector3(1.700, 0.900, 1.0), .1)
	tween.tween_property(visuals, "scale", Vector3(1.0, 1.0, 1.0), .1)
