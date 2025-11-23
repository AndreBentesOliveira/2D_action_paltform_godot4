extends "common_state.gd"

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	player.velocity = Vector3.ZERO
	player.star_invencibility()
	player.gripper_area_disable(true)
	player.gripper_area_disable(true)
	push()
	sprite.play(&"hurt")


func _physics_process(_delta: float) -> void:
	if player.is_on_floor():
		return enter_state(&"Idle")
		

func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	player.get_node("BlinkTimer").start()
	player.in_knockback = false
	player.gripper_area_disable(false)
	player.gripper_area_disable(false)


func push() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(player, "velocity", Vector3(player.knockback.x * 4.0, 2.0, 0.0), .2)
	tween.tween_property(player, "velocity", Vector3(player.knockback.x * 1.0, -5.0, 0.0), .2)

	await tween.finished
	return enter_state(&"Idle")
