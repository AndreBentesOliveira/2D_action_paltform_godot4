extends "enemy_common_state.gd"

#var knockback := Vector3.ZERO
#var knockback_timer := 0.0
#var duration = .5

#var is_up := true

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	push()
	#knockback = enemy_node._pushed_dir * 1.0
	#knockback_timer = duration
	#sprite.play(&"Stuned")


func _physics_process(_delta: float) -> void:
	pass
	#if is_up:
		#enemy_node.velocity.y += 1.0 * _delta
		#enemy_node.velocity.x += .5 * _delta
	#else:
		#enemy_node.velocity.y -= 1.0 * _delta
		#enemy_node.velocity.x += .5 * _delta
		#if enemy_node.is_on_floor():
			#return enter_state(&"Stuned")
#
	#if enemy_node.velocity.y >= 0.5:
		#is_up = false
		
		
	#if enemy_node.position.y > 500:
		#esta_em_movimento = false
		#enemy_node.position.y = 500 # Trava no chão
	#if knockback_timer > 0.0:
		#enemy_node.velocity = Vector3(knockback.x,knockback.y, 0.0)
		#knockback_timer -= _delta
		#if knockback_timer <= 0.0:
			#knockback = Vector3.ZERO
	#else:
		#return enter_state(&"Stuned")


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	pass
	#enemy_node._pushed = false
	#enemy_node._pushed_dir = Vector3.ZERO


func push():
	var tween = create_tween()
	tween.tween_property(enemy_node, "velocity", enemy_node._pushed_dir * 2.0, .3)\
	.set_trans(Tween.TRANS_QUINT)\
	.set_ease(Tween.EASE_OUT)
	await tween.finished
	var tween2 = create_tween()
	tween2.tween_property(enemy_node, "velocity", Vector3(enemy_node._pushed_dir.x * 2.0, -0.9, 0.0), .3)#\
	#.set_trans(Tween.TRANS_QUINT)\
	#.set_ease(Tween.EASE_OUT)
	
