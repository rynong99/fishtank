extends RigidBody2D
class_name Fish2
@export var speed = 1000
var velocity = Vector2.ZERO
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("p2left","p2right","p2up","p2down")
	velocity = direction*speed
	apply_central_force(velocity)
func _process(delta: float) -> void:
	if velocity.x > 0:
		$Sprite2D.flip_h = true
	elif velocity.x < 0:
		$Sprite2D.flip_h = false
