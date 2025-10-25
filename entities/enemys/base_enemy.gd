extends Entitie
class_name Enemy

@onready var hit_box_component: Hitbox = $HitBoxComponent
@onready var hurt_box: Hurtbox = $HurtBox


func enemy_start() -> void:
	pass


func _physics_process(delta: float) -> void:
	super(delta)
	if not is_on_floor():
		velocity.y -= .1 * delta
	move_and_slide()
	if grabbed:
		pass
	elif  thrown:
		#$CollisionShape3D.call_deferred("set","disabled", true)
		if hit_box_component.has_node("CollisionShape3D"):
			hit_box_component.get_node("CollisionShape3D").call_deferred("set","disabled", true)
		if hurt_box.has_node("CollisionShape3D"):
			hurt_box.get_node("CollisionShape3D").call_deferred("set","disabled", true)


func _on_state_machine_state_transitioned(old_state: StringName, new_state: StringName, state_data: Dictionary) -> void:
	$DebugLabel.text = str(new_state)
