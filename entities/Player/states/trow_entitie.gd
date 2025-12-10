extends "common_state.gd"

var is_rotating: bool = false
var entitie_sprite: Sprite3D
var ent_spr_pos = [
	Vector3(0, 0.191, 0.0), #1
	Vector3(0, 0.191, 0.0), #1
	Vector3(0, 0.191, 0.0), #2
	Vector3(-0.411, 0.191, 0.0), #3
	Vector3(-0.411, 0.369, 0.0), #4
	Vector3(-0.3, 0.800, 0.0), #5
	Vector3(0.250, 0.950, 0.0), #6
	Vector3(0.5, 0.600, 0.0), #7
	#Vector3(0.6, 0.481, 0.0) #8
]


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	entitie_sprite = visuals.get_children()[1]
	entitie_sprite.global_position.z = .050
	rotate_to_angle()
	player.velocity = Vector3.ZERO
	sprite.play(&"thrown")


func _physics_process(_delta: float) -> void:
	player.velocity = Vector3.ZERO


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	player.entitie_grabbed = []
	player.get_node("HealthComponent").invencible = false


func rotate_to_angle() -> void:
	await sprite.animation_finished
	is_rotating = false
	var entities = get_tree().get_first_node_in_group("entities_layer")
	entities.add_child(player.entitie_grabbed[0])
	player.entitie_grabbed[0].global_position = player.get_node("TrowMark").global_position
	player.entitie_grabbed[0].was_thrown(sprite.flip_h)
	visuals.get_children()[1].queue_free()
	player.grab_entitie = false
	player.gripper_component.get_node("CollisionShape3D").call_deferred("set","disabled", false)
	return enter_state(&"Idle")


func _on_sprite_3d_frame_changed() -> void:
	var rot_dir = 0
	if sprite.animation == "thrown":
		if !sprite.flip_h:
			rot_dir = 1
		else:
			rot_dir = -1
		print(sprite.frame)
		entitie_sprite.position.y = ent_spr_pos[sprite.frame].y
		entitie_sprite.position.x = ent_spr_pos[sprite.frame].x * rot_dir
		#player.get_node("Debug2/L").text = str(sprite.frame)
		#player.get_node("Debug2").position.y = ent_spr_pos[sprite.frame].y
		#player.get_node("Debug2").position.x = ent_spr_pos[sprite.frame].x * rot_dir
