extends "enemy_common_state.gd"

var stun_timer := 0.0
var stun_duration = 2.0

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	enemy_node.velocity = Vector3.ZERO
	stun_timer = stun_duration
	#sprite.play(&"stun")


func _physics_process(_delta: float) -> void:
	enemy_node._pushed = false
	enemy_node.apply_gravity(_delta)
	if enemy_node.grabbed:
		return enter_state(&"Grabbed")
	if enemy_node.hit_box_component.has_node("CollisionShape3D"):
			enemy_node.hit_box_component.get_node("CollisionShape3D").call_deferred("set","disabled", true)
	if stun_timer > 0.0:
		stun_timer -= _delta
		if stun_timer <= 0.0:
			if enemy_node.return_to_init_position:
				return enter_state(&"ReturnPatrol")
			else:
				return enter_state(&"Patrol")


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	enemy_node._pushed = false
	if new_state == "Grabbed":
		if enemy_node.hit_box_component.has_node("CollisionShape3D"):
			enemy_node.hit_box_component.get_node("CollisionShape3D").call_deferred("set","disabled", true)
	else:
		if enemy_node.hit_box_component.has_node("CollisionShape3D"):
				enemy_node.hit_box_component.get_node("CollisionShape3D").call_deferred("set","disabled", false)
