extends "common_state.gd"

var end_knockback := false
var tween_end := false

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	player.velocity = Vector3.ZERO
	tween_end = false
	player.star_invencibility()
	player.gripper_area_disable(true)
	end_knockback = false
	player.gripper_area_disable(true)
	push()
	sprite.play(&"hurt")


func _physics_process(_delta: float) -> void:
	if player.is_on_floor() and tween_end:
		player.velocity = Vector3.ZERO
		return enter_state(&"Idle")
	if end_knockback:
		player.velocity = Vector3.ZERO
		return enter_state(&"Idle")
	#if player.knockback_timer > 0.0:
		#player.velocity.x = player.knockback
		#player.knockback_timer -= _delta
		#if player.knockback_timer <= 0.0:
			#player.knockback = 0.0
	#else:
		#return enter_state(&"Idle")


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	player.in_knockback = false
	player.gripper_area_disable(false)
	player.gripper_area_disable(false)


func push():
	var tween = create_tween()
	tween.tween_property(player, "velocity", Vector3(player.knockback.x * 1.0, 1.0, 0.0), .4)#\
	#.set_ease(Tween.EASE_OUT)\
	#.set_trans(Tween.TRANS_ELASTIC)
	await tween.finished
	var tween2 = create_tween()
	tween2.tween_property(player, "velocity", Vector3(player.knockback.x * 2.0, -0.9, 0.0), .3)#\
	#.set_ease(Tween.EASE_OUT)\
	#.set_trans(Tween.TRANS_ELASTIC)
	await tween2.finished
	tween_end = true
	end_knockback = true
	#return enter_state(&"Idle")
