extends Node2D
var driving : bool = false
var reverse : bool = false
var turn_right : bool = false
var turn_left : bool = false
var can_start : bool = false
var starting : bool = false
var zapped_fish : int = 0
@export var boot : PackedScene
@export var mre : PackedScene
@export var can : PackedScene
@onready var trash_list = [boot,mre,can]

# Camera shake stuff
const SHAKE : int = 500
var camera : Camera2D

@export var decay : float = 0.6 # Time it takes to reach 0% of trauma
@export var max_offset : Vector2 = Vector2(50, 50) # Max hor/ver shake in pixels
@export var max_roll : float = 0.1 # Maximum rotation in radians (use sparingly)

@export var trauma : float = 1.5 # Current shake strength
@export var trauma_power : float = 2 # Trauma exponent. Increase for more extreme shaking\

var oo
var ox 
var oy


func _ready():
	camera = get_viewport().get_camera_2d()
	oo = camera.rotation
	ox = camera.offset.x 
	oy = camera.offset.y
	$Player1/AnimatedSprite2D.animation = "default"
	$Player2/AnimatedSprite2D.animation = "default"
	$Player1/AnimatedSprite2D.play()
	$Player2/AnimatedSprite2D.play()

func _process(delta: float) -> void:
	if GameVar.dirtiness > 10.0:
		spawn_trash()
		GameVar.dirtiness = 0
	#Stops the tank if both controls are activated
	if DirectionController.crashed:
		tank_shutdown()
	if DirectionController.running:
		GameVar.dirtiness += 2*delta
		shake(Vector2(0.25, 0.25), 0.0025) # Shake when running
		AudioManager.play_sfx("Motor")
		AudioManager.play_sfx("Water")
		if driving:
			shake(Vector2(1, 1), 0.005) # Shake when moving
			DirectionController.direction = "Forward"
			AudioManager.play_sfx("Whine")
		elif reverse:
			shake(Vector2(1, 1), 0.005) # Shake when moving
			DirectionController.direction = "Reverse"
			AudioManager.play_sfx("Whine")
		else:
			DirectionController.direction = "Stopped"
		if turn_right:
			DirectionController.rotation = "Right"
			AudioManager.play_sfx("Whine")
		elif turn_left:
			DirectionController.rotation = "Left"
			AudioManager.play_sfx("Whine")
		else:
			DirectionController.rotation = "Straight"
		if driving and reverse:
			tank_shutdown()
		if turn_left and turn_right:
			tank_shutdown()
	else:
		DirectionController.direction = "Stopped"
		DirectionController.rotation = "Straight"
		AudioManager.stop_sfx("Motor")
		AudioManager.stop_sfx("Water")
		AudioManager.stop_sfx("Whine")
		
	if starting:
		shake(Vector2(1, 1), 0.005)
	if zapped_fish != 0 and starting:
		if zapped_fish == 1:
			$Player1/AnimatedSprite2D.animation = "Zap"
			$Player1/AnimatedSprite2D.play()
		if zapped_fish == 2:
			$Player2/AnimatedSprite2D.animation = "Zap"
			$Player2/AnimatedSprite2D.play()
			
	#Activates controls and sends signals to the global tank controller
	
	if GameVar.finished:
		%GameOver.visible = true
		$GameOver/Score.text = GameVar.score

func _on_forward_body_entered(body: Node2D) -> void:
	driving = true
	#print("Driving...")

func _on_forward_body_exited(body: Node2D) -> void:
	driving = false
	#print("Stopping...")
	
func _on_reverse_body_entered(body: Node2D) -> void:
	reverse = true
	#print("Reversing...")

func _on_reverse_body_exited(body: Node2D) -> void:
	reverse = false
	#print("Stopping...")

func _on_right_body_entered(body: Node2D) -> void:
		turn_right = true
		#print("Turning Right")

func _on_right_body_exited(body: Node2D) -> void:
	if turn_right:
		turn_right = false
		#print("Going Straight")

func _on_left_body_entered(body: Node2D) -> void:
	turn_left = true

func _on_left_body_exited(body: Node2D) -> void:
	if turn_left:
		turn_left = false
		#print("Going Straight")

func _on_wires_body_entered(body: Node2D) -> void:
	if body is Fish1 or body is Fish2:
		can_start = true
		if body is Fish1:
			zapped_fish = 1
		if body is Fish2:
			zapped_fish = 2

func _on_start_button_body_entered(body: Node2D) -> void:
	if can_start:
		if not DirectionController.running:
			$StartupTimer.start()
			starting = true
			$GameStart.visible = false
			GameVar.start = true
			AudioManager.play_sfx("Electric")
				

func tank_shutdown():	 
	DirectionController.running = false
	DirectionController.direction = "Stopped"
	DirectionController.rotation = "Straight"
	shake(Vector2(0.1, 0.1), 0.05,1)
	AudioManager.play_sfx("Crash")
	for i in range(5):
		spawn_trash()
	AudioManager.stop_sfx("Motor")
	AudioManager.stop_sfx("Water")
	AudioManager.stop_sfx("Whine")
	DirectionController.crashed = false


func shake(offset : Vector2, roll : float, amount : float = 1) -> void:
	#? Set the camera's rotation and offset based on the shake strength
	#print("Shaking: ", amount)
	camera.rotation = roll * amount * randf_range(-1, 1)
	camera.offset.x = ox + offset.x * amount * randf_range(-1, 1)
	camera.offset.y = oy + offset.y * amount * randf_range(-1, 1)


func _on_startup_timer_timeout() -> void:
	DirectionController.running = true
	starting = false


func _on_wires_body_exited(body: Node2D) -> void:
	if body is Fish1 or body is Fish2:
		can_start = false


func _on_trash_timer_timeout() -> void:
	#var trash = trash_list[randi_range(0,trash_list.get_length()-1)]
	var trash = trash_list[randi_range(0,trash_list.size()-1)].instantiate()
	# Choose a random location on Path2D.
	var trash_spawn_location = $TrashPath/TrashSpawn
	trash_spawn_location.progress_ratio = randf()
	# Set the mob's position to the random location.
	trash.position = trash_spawn_location.position
	# Set the mob's direction perpendicular to the path direction.
	var direction = trash_spawn_location.rotation + PI / 2
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	trash.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	trash.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(trash)
func spawn_trash():
	var trash = trash_list[randi_range(0,trash_list.size()-1)].instantiate()
	# Choose a random location on Path2D.
	var trash_spawn_location = $TrashPath/TrashSpawn
	trash_spawn_location.progress_ratio = randf()
	# Set the mob's position to the random location.
	trash.position = trash_spawn_location.position
	# Set the mob's direction perpendicular to the path direction.
	var direction = trash_spawn_location.rotation + PI / 2
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	trash.rotation = direction
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(250.0, 350.0), 0.0)
	trash.linear_velocity = velocity.rotated(direction)
	# Spawn the mob by adding it to the Main scene.
	add_child(trash)
