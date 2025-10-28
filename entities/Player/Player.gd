extends CharacterBody3D

@export var sprite: Node
@export var ledge_grab_offset : Vector3
@onready var state_machine: StateMachine = $StateMachine
@onready var eyes_ray_cast = $EyesRayCast
@onready var head_ray_cast = $HeadRayCast
@onready var gripper_component: Gripper = $GripperComponent

@export var max_speed: float = 1.5
@export var acceleration: float = 2.0
@export var turning_acceleration : float = 5.0
@export var deceleration: float = 5.0

# GRAVITY ----- #
@export var gravity_acceleration : float = 5.0
## Won't apply gravity if falling faster than this speed to prevent massive
## acceleration in long falls.
@export_range(0, 5000) var max_gravity_falling_speed : float = 2.0
# ------------- #

# JUMP VARIABLES ------------------- #
## Height in world units. For a tile-based game, you likely want to multiply
## by tile size to tune in numbers of tiles.
@export var jump_height : float = 0.7
@export var jump_cut : float = 0.7
@export var jump_gravity_acceleration : float = 2.5
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
var can_eledge_grab := false
var grab_entitie := false
var entitie_grabbed : Array
var enemys_in_area_grabb: Array

#KNOK BACK VARIABLES
var knockback: float = 0.0
var knockback_timer : float = 0.0


func _ready() -> void:
	gripper_component.grab.connect(on_player_grab_entitie)
	%Health.text = "Health: " + str($HealthComponent.health)
	$HealthComponent.health_change.connect(on_health_changed)
	load_input_map()


func _physics_process(delta: float) -> void:
	if knockback_timer > 0.0:
		velocity.x = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = 0.0
	else:
		knockback = 0.0
	
	%VelocityY.text = str("Velocity.y: " + "%.2f" % velocity.y)
	%VelocityX.text = str("Velocity.x: " + "%.2f" % velocity.x)
	if !sprite.flip_h:
		eyes_ray_cast.position.x = 0.062
		head_ray_cast.position.x = 0.062
		eyes_ray_cast.target_position.x = 0.07
		head_ray_cast.target_position.x = 0.07
		#teste
		$RayCast1.target_position.x = 0.135
		#teste
		$TrowMark.position.x = 0.079
	else:
		eyes_ray_cast.position.x = -0.062
		head_ray_cast.position.x = -0.062
		eyes_ray_cast.target_position.x = -0.07
		head_ray_cast.target_position.x = -0.07
		#teste
		$RayCast1.target_position.x = -0.135
		#teste
		$TrowMark.position.x = -0.079
	# The following line will only be processed if 'StateMachine.auto_process' is set to 'false'.
	state_machine.call_physics_process(delta)
	velocity.z = 0
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
	add_keys.call(&"down_button", [KEY_DOWN, KEY_S])
	add_pads.call(&"down_button", [JOY_BUTTON_DPAD_DOWN])
	
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


func on_player_grab_entitie(entitie: CharacterBody3D):
	$HealthComponent.invencible = true
	gripper_area_disable(true)
	grab_entitie = true
	entitie_grabbed.append(entitie)
	if entitie_grabbed.size() == 1:
		push_enemys_away(entitie_grabbed[0])
		entitie_grabbed[0].grabbed = true
		entitie_grabbed[0].get_parent().remove_child(entitie_grabbed[0])
		if entitie.grabbed_texture == null:
			return
		var sprite_texture = Sprite3D.new()
		sprite_texture.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		sprite_texture.texture = entitie_grabbed[0].grabbed_texture
		sprite.get_parent().add_child(sprite_texture)
		sprite_texture.global_position += entitie_grabbed[0].texture_ofset_when_grabbed
	elif entitie_grabbed.size() >= 2:
		for i in range(entitie_grabbed.size()):
			if i != 0:
				pass
				#var dir = (entitie_grabbed[i].global_position - global_position).normalized()
				#entitie_grabbed[i].to_push(dir, 5.0, .5)

func push_enemys_away(entitie_grab: CharacterBody3D):
	enemys_in_area_grabb.erase(entitie_grab)
	for enemy in enemys_in_area_grabb:
		var dir = (enemy.global_position - global_position).normalized()
		enemy.to_push(Vector3(dir.x, 1.0, 0.0), 1.0, .5)


func timers(delta: float) -> void:
	# Using timer nodes here would mean unnecessary functions and node calls
	# This way everything is contained in just 1 script with no node requirements
	jump_coyote_timer -= delta
	jump_buffer_timer -= delta

func gripper_area_disable(value: bool):
	gripper_component.get_node("CollisionShape3D").call_deferred("set","disabled", value) 


func on_health_changed(health):
	%Health.text = "Health: " + str(health)


func apply_knockback(dir: float, force : float, duration: float) -> void:
	if not $HealthComponent.invencible:
		knockback = dir * force
		knockback_timer = duration




func _on_detect_enemy_body_entered(body: Node3D) -> void:
	enemys_in_area_grabb.append(body)


func _on_detect_enemy_body_exited(body: Node3D) -> void:
	enemys_in_area_grabb.erase(body)
