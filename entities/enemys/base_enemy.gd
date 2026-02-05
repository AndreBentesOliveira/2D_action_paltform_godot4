extends Entitie
class_name Enemy

@export var move_speed := 10.0
@export var return_to_init_position : bool = false
@onready var hit_box_component: Hitbox = $HitBoxComponent
@onready var hurt_box: Hurtbox = $HurtBox
var _pushed := false
var _pushed_dir : Vector3

func enemy_start() -> void:
	pushed.connect(on_entitie_pushed)
	$StateMachine.state_transitioned.connect(_on_state_machine_state_transitioned)
	$DebugLabel.text = str($StateMachine.initial_state.name)
	
	if  thrown:
		if hit_box_component.has_node("CollisionShape3D"):
			hit_box_component.get_node("CollisionShape3D").call_deferred("set","disabled", true)
		if hurt_box.has_node("CollisionShape3D"):
			hurt_box.get_node("CollisionShape3D").call_deferred("set","disabled", true)


func on_entitie_pushed(dir):
	if _pushed:
		return
	_pushed = true
	_pushed_dir = dir


@warning_ignore("unused_parameter")
func _on_state_machine_state_transitioned(old_state: StringName, new_state: StringName, state_data: Dictionary) -> void:
	$DebugLabel.text = str(new_state)


func apply_gravity(_delta):
	if not is_on_floor() and not thrown and not grabbed:
		velocity.y -= 10.0 * _delta
