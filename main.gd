extends Node3D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
			get_tree().reload_current_scene()
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
