extends "common_state.gd"

var is_rotating: bool = false

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	if !sprite.flip_h:
		rotate_to_angle(Vector3(.0, .0, -270.0), .7)
	else:
		rotate_to_angle(Vector3(.0, .0, 270.0), .7)
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
	.set_trans(Tween.TRANS_QUINT)\
	.set_ease(Tween.EASE_OUT)
	await tween.finished
	is_rotating = false
	print("Rotação para ", angulo_alvo_graus, "° concluída.")
	return enter_state(&"Idle")
	
