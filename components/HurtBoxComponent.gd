extends Area3D
class_name Hurtbox

@export var debug : bool
@export var healthcomponent : Node


func _ready() -> void:
	print(get_parent().name + " " + str(healthcomponent))
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
	
	healthcomponent. take_damage(1)


func on_ray_cast_entered(body):
	if debug:
		print(get_parent().name)
		print("body entered hurt box: " + str(body.name) + " " + str(body.get_parent()))
		print(body.get_class())
	#if not body is Enemy:
		#return
	#if healthcomponent == null:
		#return
	healthcomponent.take_damage(1)
