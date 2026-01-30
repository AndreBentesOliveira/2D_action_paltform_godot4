extends Enemy


@onready var state_machine: StateMachine = $StateMachine
@onready var health_component: Node = $HealthComponent
@onready var stop_raycast: RayCast3D = $StopRaycast
var timer : float = 0.0


func _ready() -> void:
	collide_when_thrown.connect(on_collide_When_thrown)
	start()
	enemy_start()


func _physics_process(delta: float) -> void:
	super(delta)
	state_machine.call_physics_process(delta)
	apply_gravity(delta)
	move_and_slide()


func _on_grabable_component_area_entered(area: Area3D) -> void:
	if not area is Gripper:
		return


func on_collide_When_thrown(object):
	print("Collide with " + str(object) + " " + str(object.name))
	$DeathComponent.particle_dir = thrown_dir
	if object.name == "Player":
		return
	grabbed = false
	thrown = false
	if object.has_method("on_ray_cast_entered"):
		object.on_ray_cast_entered(thrown_dir)
	health_component.explode()


func on_ray_cast_entered(particle_dir: int) -> void:
	$DeathComponent.particle_dir = -particle_dir
	health_component.explode()
