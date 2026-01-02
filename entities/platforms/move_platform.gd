@tool
extends Node3D

@export var stop_moving: bool
@export var move_to : Vector3#:
	#set(value):
		#move_to = value
		#move(value)

@export var speed : float = 1.0
@export var stop_time: float

@onready var platform = $AnimatableBody3D

var is_moving := false
var timer : float = 0.0

func _ready() -> void:
	platform.position = Vector3.ZERO
	$AnimatableBody3D/RemoteRight.position.x = $AnimatableBody3D/CollisionShape3D.shape.size.x / 2 + 0.2
	$AnimatableBody3D/RemoteLeft.position.x = -$AnimatableBody3D/CollisionShape3D.shape.size.x / 2 - 0.2
	move(move_to)


func _process(delta: float) -> void:
	$Debug_location.position = move_to
	if stop_moving:
		return
	else:
		if not is_moving:
			timer += delta
			if timer >= stop_time:
				move(move_to)
				timer = 0.0


func move(value: Vector3):
	is_moving = true
	var tween = create_tween()
	if platform.position == Vector3.ZERO:
		tween.tween_property(platform, "position", value, speed)
	else:
		tween.tween_property(platform, "position", Vector3.ZERO, speed)
	await tween.finished
	is_moving = false


func attach_player(player: CharacterBody3D):
	if platform.global_position.x < player.global_position.x:
		$AnimatableBody3D/RemoteRight.remote_path = player.get_path()
	else:
		$AnimatableBody3D/RemoteLeft.remote_path = player.get_path()

func desattach_player():
	$AnimatableBody3D/RemoteRight.remote_path = ""
	$AnimatableBody3D/RemoteLeft.remote_path = ""
