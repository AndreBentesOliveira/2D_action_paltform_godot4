extends CharacterBody3D
class_name Entitie

signal collide_when_thrown(object)

@export var can_be_grabbed : bool
@export var grabbed_texture : Texture
@export var texture_ofset_when_grabbed : Vector3
@onready var grabable_component: Grabable = $GrabableComponent
@onready var sprite: AnimatedSprite3D = $Visuals/AnimatedSprite3D
@onready var visuals : Node = $Visuals
@onready var thrown_collider: RayCast3D = $ThrownRayCasts/ThrownCollider
@onready var thrown_collider2: RayCast3D = $ThrownRayCasts/ThrownCollider2
@onready var thrown_collider3: RayCast3D = $ThrownRayCasts/ThrownCollider3

var grabbed := false
var target_gripper : CharacterBody3D
#var gripper_ofset := Vector3(0, -0.150, 0)

var thrown := false
var thrown_dir : int = 0

var knockback := Vector3.ZERO
var knockback_timer : float = 0.0


func start() -> void:
	thrown_collider.call_deferred("set","enabled", false)
	thrown_collider2.call_deferred("set","enabled", false)
	thrown_collider3.call_deferred("set","enabled", false)
	if grabable_component.has_node("CollisionShape3D"):
		if can_be_grabbed:
			grabable_component.get_node("CollisionShape3D").call_deferred("set","enabled", true)
		else:
			grabable_component.get_node("CollisionShape3D").call_deferred("set","enabled", false)


func _physics_process(delta: float) -> void:
	print(thrown)
	if knockback_timer > 0.0:
		velocity = Vector3(knockback.x,knockback.y, 0.0)
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector3.ZERO
	else:
		pass

	if is_on_floor():
		visuals.rotation.z = -self.get_floor_normal().x
	velocity.z = 0
	trow_ray_cast_manager()
	#grabbed_and_trow_logic(delta)


#func grabbed_and_trow_logic(delta):
	##if grabbed:
		##pass
	##elif thrown:
		##velocity.x = 60.0 * thrown_dir * delta
		##sprite.show()
		##visuals.rotation_degrees.z += 10.0
		#move_and_slide()


func was_thrown(direction: bool):
	grabbed = false
	thrown = true
	#thrown_collider.call_deferred("set","enabled", true)
	#thrown_collider2.call_deferred("set","enabled", true)
	#thrown_collider3.call_deferred("set","enabled", true)
	if not direction:
		thrown_dir = 1
	else:
		thrown_dir = -1
	thrown_collider.target_position.x *= thrown_dir
	thrown_collider2.target_position.x *= thrown_dir
	thrown_collider3.target_position.x *= thrown_dir


func to_push(dir: Vector3, force : float, duration: float) -> void:
	knockback = dir * force
	knockback_timer = duration


func trow_ray_cast_manager():
	if thrown_collider.is_colliding():
		collide_when_thrown.emit(thrown_collider.get_collider())
	elif thrown_collider2.is_colliding():
		collide_when_thrown.emit(thrown_collider2.get_collider())
	elif thrown_collider3.is_colliding():
		collide_when_thrown.emit(thrown_collider3.get_collider())
