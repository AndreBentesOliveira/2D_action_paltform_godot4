extends Node

signal health_changed(value)
signal take_damage(knockback)

@export var max_health : int
var health: int
var alive := true
var invencible := false


func _ready():
	health = max_health


func _take_damage(damage_amount, knockback_force):
	if invencible:
		return
	health -= damage_amount
	take_damage.emit(knockback_force)
	if health <= 0:
		explode()


func heal(amount):
	health += amount
	health = clamp(health, 0, max_health)


func health_persent():
	return health * 100 / max_health


func explode():
	get_parent().queue_free()
