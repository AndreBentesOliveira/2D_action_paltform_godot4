extends CharacterBody3D
class_name Entitie

@export var can_be_grabbed : bool
@export var grabbed_texture : Texture
@onready var grabable_component: Grabable = $GrabableComponent
@onready var sprite: AnimatedSprite3D = $Visuals/AnimatedSprite3D

var grabbed := false
var target_gripper : CharacterBody3D

var thrown := false
var thrown_dir : int


func _ready() -> void:
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
		global_position = target_gripper.global_position + Vector3(0, -0.150, 0)
		sprite.hide()
	elif thrown:
		velocity.x += (velocity.x + 0.5) * thrown_dir * delta


func was_thrown(direction: bool):
	grabbed = false
	thrown = true
	if direction:
		thrown_dir = 1
	else:
		thrown_dir = -1
