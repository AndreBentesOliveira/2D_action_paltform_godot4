extends Area3D
class_name Gripper

signal grab(entitie)
var enabled := true
@export var grip_offset : Vector3

func _ready() -> void:
	self.area_entered.connect(on_gripper_area_entered)


func on_gripper_area_entered(area):
	if not enabled:
		return
	if not area is Grabable:
		return
	
	print("GRAB " + str(area.get_parent()))
	grab.emit(area.get_parent())
