extends StateNode


var entitie: CharacterBody3D
var sprite: AnimatedSprite3D
var visuals: Node3D


func _state_machine_ready() -> void:
	entitie = get_common_node()
	sprite = entitie.get_node("Visuals/Sprite3D")
	visuals = entitie.get_node("Visuals")
