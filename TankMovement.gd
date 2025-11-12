extends CharacterBody2D


# Camera shake stuff
var camera : Camera2D

@export var decay : float = 0.6 # Time it takes to reach 0% of trauma
@export var max_offset : Vector2 = Vector2(50, 50) # Max hor/ver shake in pixels
@export var max_roll : float = 0.1 # Maximum rotation in radians (use sparingly)

@export var trauma : float = 0.0 # Current shake strength
@export var trauma_power : float = 1.5 # Trauma exponent. Increase for more extreme shaking

var speed = 50
var tank_direction = DirectionController.direction
var tank_rotation = DirectionController.rotation

func _ready():
	camera = get_viewport().get_camera_2d()

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
	move_and_slide()
	
	
	
func get_tank_direction():
	tank_direction = DirectionController.direction
func get_tank_rotation():
	tank_rotation = DirectionController.rotation

func shake() -> void:
	#? Set the camera's rotation and offset based on the shake strength
	var amount = pow(trauma, trauma_power)
	camera.rotation = max_roll * amount * randf_range(-1, 1)
	camera.offset.x = max_offset.x * amount * randf_range(-1, 1)
	camera.offset.y = max_offset.y * amount * randf_range(-1, 1)
