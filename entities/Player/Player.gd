extends CharacterBody3D


#var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

#@export var fire_component : Node
@export var sprite: Node
@export var ledge_grab_offset : Vector3
@onready var state_machine: StateMachine = $StateMachine
@onready var floor_check_ray = $FloorCheckRay
@onready var wall_check_ray = $WallCheckRay


@export var max_speed: float = 600
@export var acceleration: float = 3000
@export var turning_acceleration : float = 13500
@export var deceleration: float = 3200

# GRAVITY ----- #
@export var gravity_acceleration : float = 4500
## Won't apply gravity if falling faster than this speed to prevent massive
## acceleration in long falls.
@export_range(0, 5000) var max_gravity_falling_speed : float = 1000
# ------------- #

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
var is_hanging_on_ledge := false
var can_check_for_ledge := true

@export var max_grab_height_diff: float = 0.5
@export var min_grab_height_diff: float = -0.5 # Usamos um valor negativo para "abaixo"

func _ready() -> void:
	load_input_map()
	#state_label.text = state_machine.state


func _physics_process(delta: float) -> void:
	%VelocityY.text = str("%.2f" % velocity.y)
	#if !sprite.flip_h:
		#pass
		#$RayCastManager.position.x = 0.062
	#else:
		#pass
		#$RayCastManager.position.x = -0.062
	
	
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		$ShootSpriteCd.start()
		var proj_dir = Vector2.ZERO
		if !sprite.flip_h:
			proj_dir.x = 1
		else: proj_dir.x = -1
	# The following line will only be processed if 'StateMachine.auto_process' is set to 'false'.
	state_machine.call_physics_process(delta)
	velocity.z = 0
	#if not is_on_floor():
		#check_for_ledge()
	if not is_hanging_on_ledge:
		apply_gravity(delta)
	timers(delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	# The following line will only be processed if 'StateMachine.auto_process' is set to 'false'.
	state_machine.call_unhandled_input(event)


func _on_state_machine_state_transitioned(_old_state: StringName, new_state: StringName, _state_data: Dictionary) -> void:
	%State.text = str(new_state)


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


func apply_gravity(delta: float) -> void:
	var applied_gravity : float = 0

	# No gravity if we are grounded
	if jump_coyote_timer > 0:
		return

	# Normal gravity limit
	if velocity.y <= max_gravity_falling_speed:
		applied_gravity = gravity_acceleration * delta
	# else: we're falling too fast for more gravity.

	# If moving upwards while jumping, use jump_gravity_acceleration to achieve lower gravity
	if is_jumping and velocity.y > 0:
		applied_gravity = jump_gravity_acceleration * delta

	# Lower the gravity at the peak of our jump (where velocity is the smallest)
	if is_jumping and abs(velocity.y) > jump_hang_speed_threshold:
		applied_gravity *= jump_hang_gravity_mult

	velocity.y -= applied_gravity


func x_movement(delta: float) -> void:
	var x_dir: float = Input.get_axis(&"walk_left", &"walk_right")
	if x_dir != 0.0:
		sprite.flip_h = x_dir < 0.0
		# Brake if we're not doing movement inputs.
	if x_dir == 0:
		velocity.x = Vector2(velocity.x, 0).move_toward(Vector2.ZERO, deceleration * delta).x

	var does_input_dir_follow_momentum = sign(velocity.x) == x_dir
		# If we are doing movement inputs and above max speed, don't accelerate nor decelerate
		# Except if we are turning
		# (This keeps our momentum gained from outside or slopes)
	if abs(velocity.x) >= max_speed and does_input_dir_follow_momentum:
		return
		# Are we turning?
		# Deciding between acceleration and turn_acceleration
	var accel_rate : float = acceleration if does_input_dir_follow_momentum else turning_acceleration
		# Accelerate
	velocity.x += x_dir * accel_rate * delta


func timers(delta: float) -> void:
	# Using timer nodes here would mean unnecessary functions and node calls
	# This way everything is contained in just 1 script with no node requirements
	jump_coyote_timer -= delta
	jump_buffer_timer -= delta


func _on_shoot_sprite_cd_timeout() -> void:
	is_attacking = false
