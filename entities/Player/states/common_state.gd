extends StateNode


const SPEED = 1.0


var player: CharacterBody3D
var sprite: AnimatedSprite3D


func _state_machine_ready() -> void:
	player = get_common_node()
	sprite = player.get_node("Sprite3D")
