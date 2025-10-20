extends Entitie
class_name Enemy

@onready var hit_box_component: Hitbox = $HitBoxComponent
@onready var hurt_box: Hurtbox = $HurtBox


func enemy_start() -> void:
	pass


#func _ready() -> void:
	#start()
	
#func _physics_process(delta: float) -> void:
	#grabbed_and_trow_logic(delta)
	#if grabbed:
		#pass
	#elif  thrown:
		##$CollisionShape3D.call_deferred("set","disabled", true)
		#if hit_box_component.has_node("CollisionShape3D"):
			#hit_box_component.get_node("CollisionShape3D").call_deferred("set","disabled", true)
		#if hurt_box.has_node("CollisionShape3D"):
			#hurt_box.get_node("CollisionShape3D").call_deferred("set","disabled", true)
