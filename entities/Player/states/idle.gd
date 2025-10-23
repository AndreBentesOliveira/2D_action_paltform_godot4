extends "common_state.gd"

var is_rotating: bool = false

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	#print("Params: " + str(_params))
	if _old_state == &"TrowEntitie":
		rotate_to_angle(Vector3(0, 0, 0), .1)
	sprite.play(&"idle")


func _physics_process(_delta: float) -> void:
	if player.is_on_floor():
		if Input.get_axis(&"walk_left", &"walk_right") != 0.0:
			return enter_state(&"Walk")
	else:
		return enter_state(&"Fall")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		return enter_state(&"Jump")
	#if event.is_action_pressed(&"crouch"):
		#return enter_state(&"Crouch")


func rotate_to_angle(angulo_alvo_graus: Vector3, duracao: float) -> void:
	if is_rotating:
		return
	is_rotating = true
	var tween = create_tween()
	tween.tween_property(visuals, "rotation_degrees", angulo_alvo_graus, duracao)#\
	#.set_trans(Tween.TRANS_QUINT)\
	#.set_ease(Tween.EASE_OUT)
	await tween.finished
	is_rotating = false
	print("Rotação para ", angulo_alvo_graus, "° concluída.")
