extends CharacterBody2D


var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var fire_component : Node
@export var sprite: Node
@onready var state_machine: StateMachine = $StateMachine

@export var max_speed: float = 600
@export var acceleration: float = 3000
@export var turning_acceleration : float = 13500
@export var deceleration: float = 3200

# JUMP VARIABLES ------------------- #
## Height in world units. For a tile-based game, you likely want to multiply
## by tile size to tune in numbers of tiles.
@export var jump_height : float = 211.3
@export var jump_cut : float = 0.2
@export var jump_gravity_acceleration : float = 4000
## Speed that marks the peak of our jump. (This close to zero speed we're
## switching from moving up to moving down.) During this peak, we reduce
## gravity with jump_hang_gravity_mult to give some hang time.
@export var jump_hang_speed_threshold : float = 2.0
## Speed multiplier for the peak of our jump to reduce gravity when within
## jump_hang_speed_threshold.
@export var jump_hang_gravity_mult : float = 0.1
# Timers
@export var jump_coyote : float = 0.08
@export var jump_buffer : float = 0.1

var jump_coyote_timer : float = 0
var jump_buffer_timer : float = 0
var is_jumping := false
# ----------------------------------- #

var is_attacking := false

func _ready() -> void:
	load_input_map()
	#state_label.text = state_machine.state


func _physics_process(delta: float) -> void:
	if !sprite.flip_h:
		fire_component.position.x = 14.0
	else:
		fire_component.position.x = -14.0
		
	if not is_on_floor():
		velocity.y += gravity * 2.0 * delta
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		$ShootSpriteCd.start()
		var proj_dir = Vector2.ZERO
		if !sprite.flip_h:
			proj_dir.x = 1
		else: proj_dir.x = -1
		fire_component.shoot(proj_dir)
	# The following line will only be processed if 'StateMachine.auto_process' is set to 'false'.
	state_machine.call_physics_process(delta)
	
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	# The following line will only be processed if 'StateMachine.auto_process' is set to 'false'.
	state_machine.call_unhandled_input(event)


func _on_state_machine_state_transitioned(_old_state: StringName, new_state: StringName, _state_data: Dictionary) -> void:
	pass
	#state_label.text = new_state


func load_input_map() -> void:
	var add_keys = func(action: StringName, keycodes: Array) -> void:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		for keycode in keycodes:
			var event := InputEventKey.new()
			event.physical_keycode = keycode
			InputMap.action_add_event(action, event)
	var add_pads = func(action: StringName, button_indexes: Array) -> void:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		for button_index in button_indexes:
			var event := InputEventJoypadButton.new()
			event.button_index = button_index
			InputMap.action_add_event(action, event)
		
	# Jump
	add_keys.call(&"jump", [KEY_SPACE, KEY_UP, KEY_W])
	add_pads.call(&"jump", [JOY_BUTTON_DPAD_UP, JOY_BUTTON_A, JOY_BUTTON_B])
	
	# Crouch
	add_keys.call(&"crouch", [KEY_DOWN, KEY_S])
	add_pads.call(&"crouch", [JOY_BUTTON_DPAD_DOWN])
	
	# Walk (Left)
	add_keys.call(&"walk_left", [KEY_LEFT, KEY_A])
	add_pads.call(&"walk_left", [JOY_BUTTON_DPAD_LEFT])

	# Walk (Right)
	add_keys.call(&"walk_right", [KEY_RIGHT, KEY_D])
	add_pads.call(&"walk_right", [JOY_BUTTON_DPAD_RIGHT])


func _on_shoot_sprite_cd_timeout() -> void:
	is_attacking = false
