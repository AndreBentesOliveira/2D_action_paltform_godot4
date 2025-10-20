extends Area3D
class_name Hurtbox


@export var healthcomponent : Node


func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(area: Hitbox) -> void:
	print_debug(area.get_parent())
	if not area is Hitbox:
		return
	if healthcomponent == null:
		return
