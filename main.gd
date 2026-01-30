extends Node3D

var all_enemys : Array[Node]

func _ready() -> void:
	all_enemys = get_tree().get_nodes_in_group("enemys")
	for enemy in all_enemys:
		enemy.set_physics_process(true)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
			get_tree().reload_current_scene()
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
