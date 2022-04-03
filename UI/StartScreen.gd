extends Control

export(Resource) var ui_state

func _on_Button_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	
	ui_state.hide_ui_screen()


func _on_FullscreenButton_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
