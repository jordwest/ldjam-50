extends Spatial

export(Resource) var player_info

func _ready():
	player_info.connect("game_complete", self, "_on_game_complete")

func _on_game_complete():
	$Floor.visible = false
	$AnimationPlayer.play("Complete Game")
