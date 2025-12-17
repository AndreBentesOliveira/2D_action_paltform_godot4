extends Marker3D


@onready var jump_particles = preload("res://effects/jump_particles.tscn")
@onready var grab_particles = preload("res://effects/grab_particles.tscn")

func emitte():
	var entities = get_tree().get_first_node_in_group("entities_layer")
	var jp = jump_particles.instantiate()
	entities.add_child(jp)
	jp.global_position = self.global_position
	jp.emitting = true
