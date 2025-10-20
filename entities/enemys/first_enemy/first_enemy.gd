extends Enemy

@onready var state_machine: StateMachine = $StateMachine
@onready var health_component: Node = $HealthComponent


func _ready() -> void:
	collide_when_thrown.connect(on_collide_When_thrown)
	start()
	enemy_start()


func _on_grabable_component_area_entered(area: Area3D) -> void:
	target_gripper = area.get_parent()
	grabbed = true


func on_collide_When_thrown(object):
	if object.has_method("on_ray_cast_entered"):
		object.on_ray_cast_entered()
	health_component.explode()
	

func on_ray_cast_entered():
	health_component.explode()
