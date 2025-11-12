extends CharacterBody2D
var speed = 50
var tank_direction = DirectionController.direction
var tank_rotation = DirectionController.rotation
func _physics_process(delta: float) -> void:
	get_tank_direction()
	get_tank_rotation()
	var direction = Vector2.UP.rotated(rotation)
	if tank_rotation == "Left":
		rotation -= 0.025
	elif tank_rotation == "Right":
		rotation += 0.025
	if tank_direction == "Forward":
		velocity = speed * direction
	elif tank_direction == "Reverse":
		velocity = -speed * direction
	elif tank_direction == "Stopped":
		velocity = Vector2.ZERO
	var collision = move_and_collide(velocity*delta)
	if collision:
		DirectionController.running = false
func get_tank_direction():
	tank_direction = DirectionController.direction
func get_tank_rotation():
	tank_rotation = DirectionController.rotation
	
