extends Marker3D


@onready var jump_particles = preload("res://effects/jump_particles.tscn")
@onready var grab_particles = preload("res://effects/grab_particles.tscn")
@onready var run_particles = preload("res://effects/run_particle.tscn")


func emitte(particle: String):
	var entities = get_tree().get_first_node_in_group("entities_layer")
	var p
	match particle:
		"run_particles":
			p = run_particles.instantiate()
			p.global_position = self.global_position + Vector3(0.0, 0.30, 0.0)
			p.scale = Vector3(2.0, 2.0, 2.0)
		"jump_particles":
			p = jump_particles.instantiate()
			p.emitting = true
			#p.global_position = self.global_position
	entities.add_child(p)
	p.global_position = self.global_position
