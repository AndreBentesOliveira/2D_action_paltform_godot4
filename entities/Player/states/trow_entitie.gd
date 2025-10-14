extends "common_state.gd"

var can_rotate = true
func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	player.velocity = Vector3.ZERO
	sprite.play(&"grab_entitie")
	


func _physics_process(_delta: float) -> void:
	
	player.velocity = Vector3.ZERO
	
	
	visuals.rotation_degrees.z
	
	#player.rotation_degrees.z = clamp(player.rotation_degrees.z, 0.0, -90)


func _unhandled_input(event: InputEvent) -> void:
	pass
