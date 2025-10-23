extends "enemy_common_state.gd"


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	sprite.play(&"patrol")


func _physics_process(_delta: float) -> void:
	if enemy_node.rand_change_state(_delta):
		return enter_state(&"Idle")
	
	enemy_node.velocity.x += 0.2 * _delta
