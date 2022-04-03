class_name PlayerEvents
extends Resource

export(Resource) var skills

var player_node: Spatial

var dead = false
var complete = false

var memories_completed = 0

signal memory_captured(memory)
signal memory_complete(memory)
signal shadow_despawned
signal player_died
signal game_complete

func restart():
	memories_completed = 0
	dead = false
	complete = false
	player_node = null
	skills.restart()

func complete_game():
	emit_signal("game_complete")
	complete = true

func die():
	emit_signal("player_died")
	dead = true
