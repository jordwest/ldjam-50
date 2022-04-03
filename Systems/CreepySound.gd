extends Node

export(NodePath) var player_path
export(NodePath) var creepy_sound
export(NodePath) var shadows_container

export(Resource) var player_info

func nearest_shadow():
	var nearest_dist = null
	
	var player = get_node(player_path)
	var shadows = get_node(shadows_container)
	for shadow in shadows.get_children():
		var d = shadow.global_transform.origin.distance_to(player.global_transform.origin)
		if nearest_dist == null or d < nearest_dist:
			nearest_dist = d
	
	return nearest_dist

func _process(dt):
	var dist = nearest_shadow()
	var player = get_node(creepy_sound)
	
	if dist == null or dist > 10 or player_info.dead or player_info.complete:
		player.volume_db = -50
	else:
		var volume = lerp(0, -32, dist / 10)
		player.volume_db = volume
