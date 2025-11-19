extends CharacterBody3D

@export var sprite: Node
@export var ledge_grab_offset : Vector3
@onready var state_machine: StateMachine = $StateMachine
@onready var eyes_ray_cast : RayCast3D = $EyesRayCast
@onready var head_ray_cast: RayCast3D = $HeadRayCast
@onready var gripper_component: Gripper = $GripperComponent
@onready var go_up_raycast :RayCast3D = $RayCast3D
@onready var turnig_particles: GPUParticles3D = $TurningParticles
@export var max_speed: float = 3.0
@export var acceleration: float = 3.0
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
#-------------------------------------#
# JUMP VARIABLES WHEN GRAB ENTITIE
@export_category("GRAB JUMP")
@export var grab_jump_height: float = 1.5
@export var grab_gravity_acceleration: float = 5.0
@export var grab_jump_gravity_acceleration: float = 3.0
@export var grab_jump_hang_speed_threshold: float = 0.1
#-------------------------------------#
var is_attacking := false
var can_eledge_grab := false
var grab_entitie := false
var entitie_grabbed : Array
var enemys_in_area_grabb: Array

#KNOK BACK VARIABLES
var knockback := Vector3.ZERO
var knockback_timer : float = 0.0
var in_knockback := false

var gripper_collision: Node
var can_move_in_z := false

var can_rotate_sprite: bool

func _ready() -> void:
	gripper_component.grab.connect(on_player_grab_entitie)
	#gripper_collision = gripper_component.get_node("")
	%Health.text = "Health: " + str($HealthComponent.health)
	$HealthComponent.health_change.connect(on_health_changed)
	load_input_map()


func _physics_process(delta: float) -> void:
	if not $DetectFloorL.is_colliding() or not $DetectFloorR.is_colliding():
		can_rotate_sprite = false
	else:
		can_rotate_sprite = true
	%VelocityY.text = str("Velocity.y: " + "%.2f" % velocity.y)
	%VelocityX.text = str("Velocity.x: " + "%.2f" % velocity.x)
	if !sprite.flip_h:
		eyes_ray_cast.target_position.x = 0.333
		head_ray_cast.target_position.x = 0.333
		$RayCast1.target_position.x = 0.47
		$TrowMark.position.x = 0.434
		$DetectWall.target_position.x = 0.081
	else:
		eyes_ray_cast.target_position.x = -0.333
		head_ray_cast.target_position.x = -0.333
		$RayCast1.target_position.x = -0.47
		$TrowMark.position.x = -0.434
		$DetectWall.target_position.x = -0.081
	# The following line will only be processed if 'StateMachine.auto_process' is set to 'false'.
	state_machine.call_physics_process(delta)
	if can_move_in_z:
		pass
	else:
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
	add_keys.call(&"jump", [KEY_SPACE])
	add_pads.call(&"jump", [JOY_BUTTON_DPAD_UP, JOY_BUTTON_A, JOY_BUTTON_B])
	
	# button_down
	add_keys.call(&"down_button", [KEY_DOWN, KEY_S])
	add_pads.call(&"down_button", [JOY_BUTTON_DPAD_DOWN])
	
	# button_up
	add_keys.call(&"up_button", [KEY_UP, KEY_W])
	add_pads.call(&"up_button", [JOY_BUTTON_DPAD_UP])
	
	# Walk (Left)
	add_keys.call(&"walk_left", [KEY_LEFT, KEY_A])
	add_pads.call(&"walk_left", [JOY_BUTTON_DPAD_LEFT])

	# Walk (Right)
	add_keys.call(&"walk_right", [KEY_RIGHT, KEY_D])
	add_pads.call(&"walk_right", [JOY_BUTTON_DPAD_RIGHT])
	
	# action_button
	add_keys.call(&"action_button", [KEY_E])
	add_pads.call(&"action_button", [JOY_BUTTON_DPAD_UP])


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
	if is_jumping and velocity.y < jump_hang_speed_threshold:
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

func push_enemys_away(entitie_grab: CharacterBody3D) -> void:
	enemys_in_area_grabb.erase(entitie_grab)
	for enemy in enemys_in_area_grabb:
		var dir = (enemy.global_position - global_position).normalized()
		enemy.to_push(Vector3(dir.x, .5, 0.0))


func timers(delta: float) -> void:
	# Using timer nodes here would mean unnecessary functions and node calls
	# This way everything is contained in just 1 script with no node requirements
	jump_coyote_timer -= delta
	jump_buffer_timer -= delta


func gripper_area_disable(value: bool) -> void:
	gripper_component.get_node("CollisionShape3D").call_deferred("set","disabled", value) 


func grabedge_enable(value: bool) -> void:
	$HeadRayCast.call_deferred("set","enabled", value)
	$EyesRayCast.call_deferred("set","enabled", value)


func on_health_changed(health) -> void:
	%Health.text = "Health: " + str(health)


func apply_knockback(dir: Vector3, force : float, duration: float) -> void:
	if not $HealthComponent.invencible:
		in_knockback = true
		knockback = dir * force
		knockback_timer = duration


func star_invencibility() -> void:
	$HealthComponent.invencible = true
	$Hurtbox/CollisionShape3D.call_deferred("set","disabled", true) 
	$InvencibleTimer.start()


func _on_detect_enemy_body_entered(body: Node3D) -> void:
	enemys_in_area_grabb.append(body)


func _on_detect_enemy_body_exited(body: Node3D) -> void:
	enemys_in_area_grabb.erase(body)


func _on_invencible_timer_timeout() -> void:
	$HealthComponent.invencible = false
	$Hurtbox/CollisionShape3D.call_deferred("set","disabled", false) 
