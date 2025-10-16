extends CharacterBody3D
class_name Entitie

@export var can_be_grabbed : bool
@export var grabbed_texture : Texture
@export var texture_ofset_when_grabbed : Vector3
@onready var grabable_component: Grabable = $GrabableComponent
@onready var sprite: AnimatedSprite3D = $Visuals/AnimatedSprite3D
@onready var visuals : Node = $Visuals


var grabbed := false
var target_gripper : CharacterBody3D
var gripper_ofset := Vector3(0, -0.150, 0)


var thrown := false
var thrown_dir : int = 0


func start() -> void:
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
	if not direction:
		thrown_dir = 1
	else:
		thrown_dir = -1
	grabbed = false
	thrown = true
