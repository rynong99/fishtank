extends CharacterBody2D
@export var max_speed : int= 50
var speed : float = 0
@export var acceleration : float = 0.1
@export var turn_rate : float = 0.025
var tank_direction = DirectionController.direction
var tank_rotation = DirectionController.rotation
var crashed = false
func _physics_process(delta: float) -> void:
	get_tank_direction()
	get_tank_rotation()
	var direction = Vector2.UP.rotated(rotation)
	if tank_rotation == "Left":
		rotation_degrees -= turn_rate
	elif tank_rotation == "Right":
		rotation_degrees += turn_rate
	if tank_direction == "Forward":
		if speed <= max_speed:
			speed += acceleration
		velocity = speed * direction
	elif tank_direction == "Reverse":
		if speed <= max_speed:
			speed += acceleration
		velocity = -speed * direction
	elif tank_direction == "Stopped":
		if speed != 0:
			speed -= acceleration/10
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
