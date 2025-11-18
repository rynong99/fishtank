extends ColorRect
func _process(delta: float) -> void:
	if DirectionController.running:
		set_color(Color(0,255,0))
	else:
		set_color(Color(255,0,0))
