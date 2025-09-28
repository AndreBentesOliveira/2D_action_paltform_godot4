extends Node


@export var sprite : Node

var flash = false
var flash_shader_active


func _ready() -> void:
	if sprite == null or (sprite.material) == null:
		printerr("Sprite missing or Shader is missing")
		return
	flash_shader_active = sprite.material

func start() -> void:
	$FlasFrequency.start()
	$FlashDuration.start()


func _process(delta) -> void:
	if sprite == null or sprite.material == null:
		return
	if flash:
		flash_shader_active.set_shader_param("active", true)
	else:
		flash_shader_active.set_shader_param("active", false)


func _on_FlasFrequency_timeout() -> void:
	flash = !flash


func _on_FlashDuration_timeout() -> void:
	$FlasFrequency.stop()
	flash = false
