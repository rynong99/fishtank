extends RigidBody2D
@export var speed = 1000
var velocity = Vector2.ZERO
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("p2left","p2right","p2up","p2down")
	apply_central_force(direction*speed)
