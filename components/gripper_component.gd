extends Area3D
class_name Gripper

signal grab

func _ready() -> void:
	self.area_entered.connect(on_gripper_area_entered)


func on_gripper_area_entered(area):
	if not area is Grabable:
		return
	print("GRAB " + str(area.get_parent()))
