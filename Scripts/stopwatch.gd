extends ColorRect # Or your scene's root node type

@onready var timer_label: Label = $Label # Replace $Label with the actual path to your Label node
@onready var timer_node: Timer = $Timer   # Replace $Timer with the actual path to your Timer node
var running : bool = false
var total_time_seconds: int = 0

func _ready():
	# Connect the Timer's timeout signal to a function in this script
	timer_node.timeout.connect(_on_timer_timeout)
	# If not autostarted, call timer_node.start() here or in another function
func _process(delta: float) -> void:
	if GameVar.start and not running:	
		start_timer()
		running = true
	if GameVar.finished:	
		timer_node.stop()
		running = false
func _on_timer_timeout():
	total_time_seconds += 1
	update_timer_display()

func update_timer_display():
	var minutes = total_time_seconds / 60
	var seconds = total_time_seconds % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]
	GameVar.score = str(timer_label.text)
	
func start_timer():
	timer_node.start()

func reset_timer():
	total_time_seconds = 0
	update_timer_display()
	timer_node.start() # Restart the timer if needed
