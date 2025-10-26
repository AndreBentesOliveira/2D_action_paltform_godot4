extends Area3D
class_name Hurtbox

@export var debug : bool
@export var knock_back : bool
@export var healthcomponent : Node


func _ready() -> void:
	area_entered.connect(on_area_entered)
	#body_entered.connect(on_body_entered)

func on_area_entered(area: Area3D) -> void:
	if debug:
		print(get_parent().name)
		print("Area entered hurt box: " + str(area.name) + " " + str(area.get_parent()))
	if not area is Hitbox:
		return
	if healthcomponent == null:
		return
	
	healthcomponent.take_damage(1)
	if knock_back:
		var knockback_direction = (area.global_position - global_position).normalized()
		get_parent().apply_knockback(-knockback_direction.x, 1.0, 0.5)
