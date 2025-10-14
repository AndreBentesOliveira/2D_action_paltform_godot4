extends Enemy

@onready var state_machine: StateMachine = $StateMachine


func _ready() -> void:
	start()


func _physics_process(delta: float) -> void:
	state_machine.call_physics_process(delta)
	grabbed_and_trow_logic(delta)


func _on_grabable_component_area_entered(area: Area3D) -> void:
	print(area.get_parent())
	sprite.play("invisible")
	target_gripper = area.get_parent()
	$CollisionShape3D.call_deferred("set_disabled", true) 
	grabbed = true
	print(grabbed)
