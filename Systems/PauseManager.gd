extends Node

var consecutive_uncaptured = 0

func _process(dt):
	# Pause game whenever mouse is not captured
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		consecutive_uncaptured += 1
		if consecutive_uncaptured > 3:
			get_tree().paused = true
	else:
		consecutive_uncaptured = 0
		get_tree().paused = false
