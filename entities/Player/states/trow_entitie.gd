extends "common_state.gd"

var jump_grab_entitie := false

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	player.velocity = Vector3.ZERO
	sprite.play(&"grab_entitie")
	player.entitie_grabbed.was_thrown(sprite.flip_h)


func _physics_process(_delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	pass
