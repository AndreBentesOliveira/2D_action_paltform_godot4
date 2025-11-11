extends "common_state.gd"

var is_rotating: bool = false
var entitie_sprite: Sprite3D
var ent_spr_pos = [
	Vector3(0, 0.191, 0.0),
	Vector3(0, 0.191, 0.0),
	Vector3(0, 0.191, 0.0),
	Vector3(0, 0.191, 0.0),
	Vector3(-0.411, 0.369, 0.0),
	Vector3(-0.47, 0.461, 0.0),
	Vector3(-0.38, 0.829, 0.0),
	Vector3(0.298, 0.882, 0.0),
	Vector3(0.434, 0.481, 0.0)
]


func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	entitie_sprite = visuals.get_children()[1]
	rotate_sprite()
	if !sprite.flip_h:
		rotate_to_angle(Vector3(.0, .0, -270.0), .2)
	else:
		rotate_to_angle(Vector3(.0, .0, 270.0), .2)
	player.velocity = Vector3.ZERO
	sprite.play(&"thrown")
	


func _physics_process(_delta: float) -> void:
	player.velocity = Vector3.ZERO
	print(sprite.frame)


func _unhandled_input(event: InputEvent) -> void:
	pass


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	player.entitie_grabbed = []
	player.get_node("HealthComponent").invencible = false



func rotate_sprite():
	pass


func rotate_to_angle(angulo_alvo_graus: Vector3, duracao: float) -> void:
	#if is_rotating:
		#return
	#is_rotating = true
	#var tween = create_tween()
	#tween.tween_property(sprite, "rotation_degrees", angulo_alvo_graus, duracao)\
	##.set_trans(Tween.TRANS_QUINT)\
	#.set_ease(Tween.EASE_OUT)
	#await tween.finished
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
