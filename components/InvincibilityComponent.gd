extends Node

@export var sprite : Node
@export var helth_component : Node


var flash: = false

func _ready() -> void:
	pass


func start_blink() -> void:
#	get_node(helth_component).invencible = true
	owner.get_node("HurtBox/CollisionShape2D").disabled = true
	$InvincibilityFrequence.start()
	$InvincibilityDuration.start()


func _process(delta) -> void:
	if flash:
		sprite.modulate = Color(1, 1, 1, 0)
	else:
		sprite.modulate = Color(1, 1, 1, 1)


func _on_InvincibilityFrequence_timeout() -> void:
	flash = !flash


func _on_InvincibilityDuration_timeout() -> void:
	helth_component.invencible = false
	owner.get_node("HurtBox/CollisionShape2D").disabled = false
	$InvincibilityFrequence.stop()
	flash = false


func _on_CowndownStart_timeout():
	start_blink()
