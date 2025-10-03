extends Node

signal health_changed(value)
signal _take_damage(knockback)

@export var max_health : int
@export var debug : bool
var health: int
var alive := true
var invencible := false


func _ready():
	if debug:
		print("Health: %s/%s" % [health, max_health])
	health = max_health


func take_damage(damage_amount, knockback_force):
	if debug:
		print("take damage %s, Health: %s/%s" % [damage_amount, health, max_health])
	if invencible:
		return
	health -= damage_amount
	_take_damage.emit(knockback_force)
	if health <= 0:
		explode()


func heal(amount):
	if debug:
		print("heal %s, Health: %s/%s"% [amount, health, max_health])
	health += amount
	health = clamp(health, 0, max_health)


func health_persent():
	return health * 100 / max_health


func explode():
	if debug:
		print(str(get_parent().name) + " die")
	get_parent().queue_free()
