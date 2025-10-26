extends Node3D
class_name Grabable

signal grabbed(entitie)
var enabled := true


func on_grabable_area_entered(area):
	print(area)
	if area is not Gripper:
		return
	if not enabled:
		return
	if not area.enabled:
		return
	grabbed.emit(area.get_parent())
