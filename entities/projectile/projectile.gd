extends Node2D


@export var speed = 300
var direction = Vector2(0, 0)

func _ready():
	$LifeTime.timeout.connect(on_lifetime_timeout)
	$HitBoxComponent.area_entered.connect(on_hitbox_area_entered)


func _process(delta):
	position += direction * speed * delta


func on_hitbox_area_entered(area: Area2D):
	explode()


func on_lifetime_timeout():
	explode()


func explode():
	queue_free()
