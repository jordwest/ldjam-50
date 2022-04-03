extends Node

export(bool) var enabled = true

export(Resource) var player_info

func _unhandled_input(event):
	if not enabled:
		return
	
	if event.is_action_pressed("debug_command"):
		player_info.memories_completed = 5
		#player_info.complete_game()
