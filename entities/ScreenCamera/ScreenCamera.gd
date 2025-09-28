extends Camera2D

@export var player: NodePath
@export var segment_size = Vector2(320, 180) # Tamanho do segmento da câmera

var current_segment = Vector2()

func _ready():
	#set_camera_limit()
	var player_node = get_node(player)
	current_segment = get_camera_segment(player_node.global_position)
	update_camera_position()

func _process(delta):
	var player_node = get_node(player)
	if player_node:
		var player_segment = get_camera_segment(player_node.global_position)
		if player_segment != current_segment:
			current_segment = player_segment
			update_camera_position()

func get_camera_segment(position):
	return Vector2(
		floor(position.x / segment_size.x),
		floor(position.y / segment_size.y)
	)

func update_camera_position():
	global_position = current_segment * segment_size + segment_size / 2


#func set_camera_limit():
	#var map_limits = owner.get_node("Background").get_used_rect()
	#var map_cellsize = owner.get_node("Background").cell_size
	#limit_left = map_limits.position.x * map_cellsize.x
	#limit_right = map_limits.end.x * map_cellsize.x
	#limit_top = map_limits.position.y * map_cellsize.y
	#limit_bottom = map_limits.end.y * map_cellsize.y
