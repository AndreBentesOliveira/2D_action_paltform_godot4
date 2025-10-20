extends CharacterBody3D
class_name Entitie

signal collide_when_thrown(object)

@export var can_be_grabbed : bool
@export var grabbed_texture : Texture
@export var texture_ofset_when_grabbed : Vector3
@onready var grabable_component: Grabable = $GrabableComponent
@onready var sprite: AnimatedSprite3D = $Visuals/AnimatedSprite3D
@onready var visuals : Node = $Visuals
@onready var thrown_collider: RayCast3D = $ThrownCollider


var grabbed := false
var target_gripper : CharacterBody3D
var gripper_ofset := Vector3(0, -0.150, 0)


var thrown := false
var thrown_dir : int = 0


func start() -> void:
	thrown_collider.call_deferred("set","enabled", false)
	if sprite.sprite_frames != null:
		pass
	if can_be_grabbed:
		grabable_component.enabled = true
	else:
		grabable_component.enabled = false


func _physics_process(delta: float) -> void:
	pass


func grabbed_and_trow_logic(delta):
	if grabbed:
		global_position = target_gripper.global_position + gripper_ofset
		sprite.hide()
	elif thrown:
		velocity.x = 80.0 * thrown_dir * delta
		sprite.show()
		visuals.rotation_degrees.z += 10.0
		move_and_slide()


func was_thrown(direction: bool):
	thrown_collider.call_deferred("set","enabled", true)
	if not direction:
		thrown_dir = 1
	else:
		thrown_dir = -1
	thrown_collider.target_position.x *= thrown_dir
	grabbed = false
	thrown = true


func trow_ray_cast_manager():
	if thrown_collider.is_colliding():
		#print("BATEU: " + str(thrown_collider.get_collider()))
		grabbed = false
		thrown = false
		collide_when_thrown.emit(thrown_collider.get_collider())
