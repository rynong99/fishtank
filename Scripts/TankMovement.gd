extends CharacterBody2D
@export var max_speed : int= 25
var speed : float = 0
@export var acceleration : float = 0.1
@export var turn_rate : float = 1
var tank_direction = DirectionController.direction
var tank_rotation = DirectionController.rotation
var crashed = false

var total_distance : float
var progress_bar : ProgressBar
var progress : PathFollow2D
var speedometer : TextureProgressBar
	
func _ready() -> void:
	# Get the total distance to finish the course
	#total_distance = %Start_Line.get_child(0).position.distance_to(%Finish_Line.get_child(0).position)
	#print(total_distance)
	progress_bar = find_parent("OutsideViewer").find_child("ProgressBar")
	#progress = %Progress
	print(progress_bar.value)
	speedometer = find_parent("OutsideViewer").find_child("Speedometer")

func _process(_delta: float) -> void:
	#var progress = position.distance_to(%Finish_Line.get_child(0).position)
	print(progress) 
	#progress_bar.value = remap(progress, total_distance, 0, 0, 100.0)
	%Progress.progress = %Path.get_curve().get_baked_length() + %Tank.position.y
	progress_bar.value = remap(%Progress.progress_ratio,0,1,100,0)
	print(progress_bar.value)

func _physics_process(delta: float) -> void:
	get_tank_direction()
	get_tank_rotation()
	var prev_vel = velocity
	var direction = Vector2.UP.rotated(rotation)
	if tank_rotation == "Left":
		rotation -= turn_rate*delta/5
	elif tank_rotation == "Right":
		rotation += turn_rate*delta/5
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
			speed -= acceleration/7.5
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
	
	speedometer.value = remap(speed, 0, max_speed, 0 , 100.0)

func get_tank_direction():
	tank_direction = DirectionController.direction
func get_tank_rotation():
	tank_rotation = DirectionController.rotation
