extends CharacterBody2D
var max_speed = 50
var speed = 0
var tank_direction = DirectionController.direction
var tank_rotation = DirectionController.rotation
var crashed = false
func _physics_process(delta: float) -> void:
	get_tank_direction()
	get_tank_rotation()
	var direction = Vector2.UP.rotated(rotation)
	if tank_rotation == "Left":
		rotation -= 0.025
	elif tank_rotation == "Right":
		rotation += 0.025
	if tank_direction == "Forward":
		if speed <= max_speed:
			speed += 0.5
		velocity = speed * direction
	elif tank_direction == "Reverse":
		if speed <= max_speed:
			speed += 0.5
		velocity = -speed * direction
	elif tank_direction == "Stopped":
		if speed > 0:
			speed -= 0.5
		if speed != 0:
			if velocity < Vector2.ZERO:
				velocity = -speed * direction
			elif velocity > Vector2.ZERO:
				velocity = speed * direction
		else:
			velocity = Vector2.ZERO
	var collision = move_and_collide(velocity*delta)
	if collision and abs(speed) >= max_speed:
		if not crashed:
			DirectionController.running = false
			crashed = true
			speed = 0
	else:
		crashed = false

func get_tank_direction():
	tank_direction = DirectionController.direction
func get_tank_rotation():
	tank_rotation = DirectionController.rotation
