extends "common_state.gd"

var is_rotating: bool = false

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	if !sprite.flip_h:
		rotate_to_angle(Vector3(.0, .0, -270.0), .2)
	else:
		rotate_to_angle(Vector3(.0, .0, 270.0), .2)
	player.velocity = Vector3.ZERO
	sprite.play(&"grab_entitie")
	


func _physics_process(_delta: float) -> void:
	player.velocity = Vector3.ZERO


func _unhandled_input(event: InputEvent) -> void:
	pass


func rotate_to_angle(angulo_alvo_graus: Vector3, duracao: float) -> void:
	if is_rotating:
		return
	is_rotating = true
	var tween = create_tween()
	tween.tween_property(visuals, "rotation_degrees", angulo_alvo_graus, duracao)\
	#.set_trans(Tween.TRANS_QUINT)\
	.set_ease(Tween.EASE_OUT)
	await tween.finished
	is_rotating = false
	print("Rotação para ", angulo_alvo_graus, "° concluída.")
	var entities = get_tree().get_first_node_in_group("entities_layer")
	entities.add_child(player.entitie_grabbed)
	player.entitie_grabbed.global_position = player.get_node("TrowMark").global_position
	player.entitie_grabbed.was_thrown(sprite.flip_h)
	visuals.get_children()[1].queue_free()
	player.grab_entitie = false
	player.gripper_component.get_node("CollisionShape3D").call_deferred("set","disabled", false)
	return enter_state(&"Idle")
