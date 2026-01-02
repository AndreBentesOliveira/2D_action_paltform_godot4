extends Camera3D

@export var target: Node3D
@export var smooth_speed: float = 5.0
@export var dead_zone_size: Vector2 = Vector2(1, 1)
@export var base_offset: Vector3 = Vector3(0, -0.5, 0.0)
@export var look_ahead_amount: float = 80.0
@export var offset_smooth_speed: float = 3.0


var current_offset: Vector3


func _ready() -> void:
	current_offset = base_offset
	if target:
		global_position = target.global_position + current_offset


func _process(delta: float) -> void:
	if not target:
		return

	var target_offset = base_offset
	var player_direction: float = 1.0
	
	if target.get_node("Visuals/Sprite3D").flip_h:
		player_direction = -1.0
	else:
		player_direction = 1.0
	
	if target.current_state == "GrabEdge" or target.current_state == "GrabWall":
		target_offset.x += 1.0 * -player_direction
	else:
		target_offset.x += look_ahead_amount * player_direction
	current_offset = current_offset.lerp(target_offset, offset_smooth_speed * delta)
	
	var target_pos = target.global_position + current_offset
	var camera_pos = global_position
	var new_camera_pos = camera_pos
	var diff = target_pos - camera_pos
	
	if abs(diff.x) > dead_zone_size.x:
		new_camera_pos.x = target_pos.x - (dead_zone_size.x * sign(diff.x))
	
	if abs(diff.y) > dead_zone_size.y:
		new_camera_pos.y = target_pos.y - (dead_zone_size.y * sign(diff.y))
	new_camera_pos.z = target_pos.z
	
	global_position = global_position.lerp(new_camera_pos, smooth_speed * delta)
