extends Control

export(Resource) var ui_state
export(Resource) var player_info

func _ready():
	pass

func _on_RestartButton_pressed():
	get_tree().reload_current_scene()
	ui_state.restart()
	player_info.restart()
	
