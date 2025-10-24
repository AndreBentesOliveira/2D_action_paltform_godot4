extends Camera3D

@export var target: Node3D
@export var smoothness: float = 0.5
@export var offset: Vector3 = Vector3(0, 5, 10)


func _process(delta: float) -> void:
	if not target:
		return
	var target_position = target.global_position + offset
	global_position = global_position.lerp(target_position, smoothness * delta)
