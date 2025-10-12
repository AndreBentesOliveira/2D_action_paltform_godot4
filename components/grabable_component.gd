extends Node3D
class_name Grabable


func _ready() -> void:
	self.selarea_entered.connect(on_grabable_area_entered)


func on_grabable_area_entered(area: Area3D):
	pass
