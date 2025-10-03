extends Marker2D


@export var projectile_scene : PackedScene


func _ready() -> void:
	pass


func shoot(projectile_direction: Vector2) -> void:
	var projectile_instance = projectile_scene.instantiate()
	projectile_instance.position = self.global_position
	get_parent().get_parent().add_child(projectile_instance)
	projectile_instance.direction = projectile_direction
#	projectile_instance.transform = self.transform
