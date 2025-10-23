extends Node3D

@export var health_component : Node
@export var texture : Texture

func _ready() -> void:
	#if not texture == null:
		#$GPUParticles3D.draw_pass_1.material.albedo_texture = texture
	if not health_component == null:
		health_component.die.connect(on_died)


func on_died():
	if owner == null || not owner is Node3D:
		return
	var spawn_position = owner.global_position
	var entities = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities.add_child(self)
	
	global_position = spawn_position
	$AnimationPlayer.play("default")
	
