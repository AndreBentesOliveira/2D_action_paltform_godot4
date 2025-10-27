extends "enemy_common_state.gd"

var timer : float
var dir : int = 0

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	pass
	#sprite.play(&"patrol")


func _physics_process(_delta: float) -> void:
	if enemy_node.rand_change_state(_delta):
		return enter_state(&"Idle")
	
	enemy_node.velocity.x = 10.0 * _delta
	enemy_node.move_and_slide()
