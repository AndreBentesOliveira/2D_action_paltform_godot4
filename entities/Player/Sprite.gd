extends Node2D
# This is a hacky way of doing animation
# I do not advise you using this in real projects
# Instead learn how to use a STATE MACHINE
# https://www.youtube.com/results?search_query=godot+state+machine
# Choose a video of your liking
@onready var Animator := $AnimationPlayer
@onready var player := get_parent()
var previous_frame_velocity := Vector2(0,0)


# Avoid errors
func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if previous_frame_velocity.y >= 0 and player.velocity.y < 0:
		Animator.play("Jump")
	elif previous_frame_velocity.y > 0 and player.is_on_floor():
		Animator.play("Land")
	
	# It's important that this is the last thing done
	previous_frame_velocity = player.velocity


func animation_control(animation: String, shooting: = false):
	match animation:
		"IDLE":
			if shooting:
				animation += "_SHOOT"
		"WALK":
			if shooting:
				animation += "_SHOOT"
		"JUMP":
			if shooting:
				animation += "_SHOOT"
		"HURT":
			$AnimatedSprite.play("HURT")
			
	$AnimatedSprite.play(animation)
