extends "common_state.gd"

var eledge_grab := false
var entitie_grab : = false
var wall_jump := false
func _enter_state(_old_state: StringName, _params: Dictionary) -> void:
	player.gripper_area_disable(false)
	stretch()
	visuals.rotation = Vector3.ZERO
	eledge_grab = false
	entitie_grab = false
	wall_jump = false
	if _old_state == "GrabWall":
		wall_jump = true
		player.get_node("DetectWall").enabled = false
		player.get_node("DetectWall").enabled = false
		await get_tree().create_timer(0.1).timeout
		player.get_node("DetectWall").enabled = true
		player.get_node("DetectWall").enabled = true
	if _old_state == "GrabEntitie":
		entitie_grab = true
	if _old_state == "GrabEdge":
		eledge_grab = true
		player.head_ray_cast.enabled = false
		player.eyes_ray_cast.enabled = false
		await get_tree().create_timer(0.1).timeout
		player.head_ray_cast.enabled = true
		player.eyes_ray_cast.enabled = true
	sprite.play(&"jump")


func _physics_process(_delta: float) -> void:
	player.x_movement(_delta)
	player.apply_gravity(_delta)
	check_for_ledge()
	if player.can_eledge_grab:
		return enter_state(&"GrabEdge")
	if player.grab_entitie:
		return enter_state(&"GrabEntitie")
	if player.in_knockback:
		return enter_state(&"Knockback")
	#if player.get_node("DetectWall").is_colliding():
		#return enter_state(&"GrabWall")
	if player.is_on_wall() and player.get_node("DetectWall").is_colliding():
		return enter_state(&"GrabWall")
	#if already_jump:
		#if player.is_on_floor():
			#return enter_state(&"TrowEntitie")
	if name == &"Jump":
		if player.velocity.y <= 0.0:
			return enter_state(&"Fall")

func _exit_state(new_state: StringName, state_data: Dictionary) -> void:
	if new_state == "GrabEdge":
		player.velocity == Vector3.ZERO


func get_input() -> Dictionary:
	return {
		"just_jump": Input.is_action_just_pressed("jump"),
		"jump": Input.is_action_pressed("jump"),
		"released_jump": Input.is_action_just_released("jump")
	}




func check_for_ledge():
	player.can_eledge_grab = not player.head_ray_cast.is_colliding() and player.eyes_ray_cast.is_colliding()


func stretch():
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector3(0.762, 1.323, 1.0), .1)
	tween.tween_property(sprite, "scale", Vector3(1.0, 1.0, 1.0), .1)
