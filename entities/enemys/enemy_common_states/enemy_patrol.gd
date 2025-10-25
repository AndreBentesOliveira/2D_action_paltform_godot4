extends "enemy_common_state.gd"

var timer : float
var dir : int = 0

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	sprite.play(&"patrol")


func _physics_process(_delta: float) -> void:
	if enemy_node.rand_change_state(_delta):
		return enter_state(&"Idle")
