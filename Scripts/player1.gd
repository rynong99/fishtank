extends RigidBody2D
class_name Fish1
@export var speed = 1000
var velocity = Vector2.ZERO
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("p1left","p1right","p1up","p1down")
	velocity = direction*speed
	apply_central_force(velocity)
func _process(delta: float) -> void:
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
