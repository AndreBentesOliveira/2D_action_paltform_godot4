extends Enemy

@onready var state_machine: StateMachine = $StateMachine


func _ready() -> void:
	start()
	enemy_start()


func _on_grabable_component_area_entered(area: Area3D) -> void:
	target_gripper = area.get_parent()
	grabbed = true
	$CollisionShape3D.call_deferred("set","disabled", true)
