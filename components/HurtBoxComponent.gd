extends Area2D
class_name HurtboxComponent


@export var healthcomponent : Node
@export var hitflashcomponent : Node


func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(area: Area2D) -> void:
	if hitflashcomponent != null:
		hitflashcomponent.start()
	if not area is HitboxComponent:
		return
	if healthcomponent == null:
		return
	
	var knockback = -1 if(area.global_position.x - global_position.x) > 0 else 1
	knockback = knockback * area.knockback_force
	healthcomponent.take_damage(area.damage, knockback)
