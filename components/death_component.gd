extends Node3D

@export var health_component : Node
@export var texture : Texture

func _ready() -> void:
	if not texture == null:
		$GPUParticles3D.texture = texture
	if not health_component == null:
		health_component.die.connect(on_died)


func on_died():
	var entities = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
