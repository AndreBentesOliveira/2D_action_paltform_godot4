extends Node3D
class_name Grabable

signal grabbed(entitie)
var enabled := true

func _ready() -> void:
	pass


func on_grabable_area_entered(area):
	if not enabled:
		return
	grabbed.emit(area.get_parent())
