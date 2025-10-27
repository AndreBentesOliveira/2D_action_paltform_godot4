extends "enemy_common_state.gd"


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	enemy_node.velocity = Vector3.ZERO
	sprite.play(&"idle")


func _physics_process(_delta: float) -> void:
	if entitie
	if enemy_node.rand_change_state(_delta):
		return enter_state(&"Patrol")
