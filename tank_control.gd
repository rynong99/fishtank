extends Node2D
var driving : bool = false
var reverse : bool = false
var turn_right : bool = false
var turn_left : bool = false
var can_start : bool = false


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


func _process(delta: float) -> void:
	#Stops the tank if both controls are activated
	if DirectionController.running:
		if driving:
			shake(Vector2(1, 1), 0.005)
			DirectionController.direction = "Forward"
		elif reverse:
			shake(Vector2(1, 1), 0.005)
			DirectionController.direction = "Reverse"
		else:
			DirectionController.direction = "Stopped"
		if turn_right and (driving or reverse):
			DirectionController.rotation = "Right"
		elif turn_left and (driving or reverse):
			DirectionController.rotation = "Left"
		else:
			DirectionController.rotation = "Straight"
		if driving and reverse:
			tank_shutdown()
		if turn_left and turn_right:
			tank_shutdown()
	else:
		DirectionController.direction = "Stopped"
		DirectionController.rotation = "Straight"
	#Activates controls and sends signals to the global tank controller
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
func _on_start_button_body_entered(body: Node2D) -> void:
	if can_start:
		if not DirectionController.running:
			DirectionController.running = true
func tank_shutdown():
	DirectionController.running = false
	DirectionController.direction = "Stopped"
	DirectionController.rotation = "Straight"



func shake(offset : Vector2, roll : float, amount : float = 1) -> void:
	#? Set the camera's rotation and offset based on the shake strength
	#print("Shaking: ", amount)
	camera.rotation = roll * amount * randf_range(-1, 1)
	camera.offset.x = ox + offset.x * amount * randf_range(-1, 1)
	camera.offset.y = oy + offset.y * amount * randf_range(-1, 1)
