extends "common_state.gd"

var slide_max_speed := 10.0
var slide_speed := 4.0

func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	#player.floor_max_angle = deg_to_rad(70)
	sprite.play(&"slide")


func _physics_process(_delta: float) -> void:
	#print(rad_to_deg(player.get_floor_angle()))
	sprite.position.y = 0.344
	player.apply_gravity(_delta)
	if not is_zero_approx(player.get_floor_angle()):
		if not abs(player.velocity.x) >= slide_max_speed:
			if player.get_floor_normal().x > 0.0:
				player.velocity.x += slide_speed * _delta
			else:
				player.velocity.x -= slide_speed * _delta
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, .05)
		if abs(player.velocity.x) < 0.5:
			return enter_state(&"Idle")
	if rad_to_deg(player.get_floor_angle()) >= 90.0:
		return enter_state(&"Fall")


func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	sprite.position.y = 0.62
	#player.floor_max_angle = deg_to_rad(70)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump") and (is_zero_approx(player.get_floor_angle()) or rad_to_deg(player.get_floor_angle()) <= 25.0):
		return enter_state(&"Jump")
