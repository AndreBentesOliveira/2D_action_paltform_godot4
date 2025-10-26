extends Node

signal health_changed(value)
signal die
signal health_change(current_health)


@export var max_health : int
@export var debug : bool

var health: int
var alive := true
var invencible := false


func _ready():
	health = max_health
	health_change.emit(health)
	if debug:
		print("Health: %s/%s" % [health, max_health])


func take_damage(damage_amount):
	if invencible:
		return
	health -= damage_amount
	if debug:
		print("take damage %s, Health: %s/%s" % [damage_amount, health, max_health])
	health_change.emit(health)
	if health <= 0:
		explode()


func heal(amount):
	health += amount
	health = clamp(health, 0, max_health)
	health_change.emit(health)
	if debug:
		print("heal %s, Health: %s/%s"% [amount, health, max_health])


func health_persent():
	return health * 100 / max_health


func explode():
	if debug:
		print(str(get_parent().name) + " die")
	die.emit()
	get_parent().queue_free()
