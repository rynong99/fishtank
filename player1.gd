extends RigidBody2D
class_name Fish2
@export var speed = 1000
var velocity = Vector2.ZERO
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("p1left","p1right","p1up","p1down")
	apply_central_force(direction*speed)
