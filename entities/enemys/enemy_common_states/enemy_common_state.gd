extends StateNode
class_name CommonEnemyState

var enemy_node: CharacterBody3D
var sprite: AnimatedSprite3D
var visuals: Node3D

func _state_machine_ready() -> void:
	enemy_node = get_common_node()
	sprite = enemy_node.get_node("Visuals/AnimatedSprite3D")
	visuals = enemy_node.get_node("Visuals")
