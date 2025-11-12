extends Node2D
var driving : bool = false
var reverse : bool = false
var turn_right : bool = false
var turn_left : bool = false
var can_start : bool = false

func _process(delta: float) -> void:
	#Stops the tank if both controls are activated
	if DirectionController.running:
		if driving:
			DirectionController.direction = "Forward"
		elif reverse:
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
			DirectionController.direction = "Stopped"
		if turn_left and turn_right:
			DirectionController.direction = "Stopped"
			DirectionController.rotation = "Straight"
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
