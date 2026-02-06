extends "common_state.gd"

var att_dir := 0.0

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	if !_old_state == "Fall":
		var friction_dir : int
		if !sprite.flip_h:
			friction_dir = 1
		else:
			friction_dir = -1
		player.velocity -= Vector3(friction_dir * 1,0,0)
	sprite.play(&"place_holder")
	attack()


func _physics_process(_delta: float) -> void:
	player.apply_gravity(_delta)
	player.jump_logic(_delta)
	player.x_movement(_delta)
	
	if player.get_node("Weapon").is_colliding():
		if is_instance_valid(player.get_node("Weapon").get_collider()):
			player.get_node("Weapon").get_collider().to_push(Vector3(att_dir, 2.0, .0))


@warning_ignore("unused_parameter")
func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	pass


func attack() -> void:
	if !sprite.flip_h:
		att_dir = 1
	else:
		att_dir = -1
	player.is_attacking = true
	var tween = create_tween()
	tween.tween_property(player.get_node("Weapon"),"target_position", Vector3(2.0 * att_dir, .0, .0), .4)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_BACK)
	tween.tween_property(player.get_node("Weapon"),"target_position", Vector3(0.0, 0.0, 0.0), 0.1)
	await tween.finished
	return enter_state(&"Fall")
