extends Enemy

@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	state_machine.call_physics_process(delta)
