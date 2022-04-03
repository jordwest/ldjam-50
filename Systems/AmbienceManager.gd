extends Node

export(NodePath) var completion_stream
export(NodePath) var ambience_stream
export(NodePath) var action_stream

export(Resource) var player_info

func _ready():
	player_info.connect("game_complete", self, "_on_game_complete")

func _on_game_complete():
	get_node(completion_stream).play()
	get_node(ambience_stream).stop()
	get_node(action_stream).fade_out()
