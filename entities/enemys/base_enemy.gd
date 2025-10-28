extends Entitie
class_name Enemy

@onready var hit_box_component: Hitbox = $HitBoxComponent
@onready var hurt_box: Hurtbox = $HurtBox
var _pushed := false
var _pushed_dir : Vector3

func enemy_start() -> void:
	pushed.connect(on_entitie_pushed)


func _physics_process(delta: float) -> void:
	super(delta)
	
	#if not is_on_floor() and not thrown and not grabbed:
		#velocity.y -= 10.0 * delta
	#else:
		#pass
	move_and_slide()
	
	if  thrown:
		if hit_box_component.has_node("CollisionShape3D"):
			hit_box_component.get_node("CollisionShape3D").call_deferred("set","disabled", true)
		if hurt_box.has_node("CollisionShape3D"):
			hurt_box.get_node("CollisionShape3D").call_deferred("set","disabled", true)


func on_entitie_pushed(dir):
	_pushed = true
	_pushed_dir = dir


func _on_state_machine_state_transitioned(old_state: StringName, new_state: StringName, state_data: Dictionary) -> void:
	$DebugLabel.text = str(new_state)
