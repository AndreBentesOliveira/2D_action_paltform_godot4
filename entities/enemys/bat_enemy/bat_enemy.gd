extends Enemy

enum move_type{move_h, move_v}
@export var move_type_: move_type

@onready var state_machine: StateMachine = $StateMachine
@onready var health_component: Node = $HealthComponent

var init_position : Vector3
var timer : float = 0.0

func _ready() -> void:
	init_position = global_position
	collide_when_thrown.connect(on_collide_When_thrown)
	start()
	enemy_start()


func _physics_process(delta: float) -> void:
	super(delta)
	move_and_slide()


func _on_grabable_component_area_entered(area: Area3D) -> void:
	if not area is Gripper:
		return


func on_collide_When_thrown(object):
	print("Collide with " + str(object) + " " + str(object.name))
	if object.name == "Player":
		return
	grabbed = false
	thrown = false
	if object.has_method("on_ray_cast_entered"):
		object.on_ray_cast_entered(thrown_dir)
	health_component.explode()


func on_ray_cast_entered():
	health_component.explode()
