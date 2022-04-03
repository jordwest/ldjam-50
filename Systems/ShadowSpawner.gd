extends Node

export(Resource) var player_info
export(Resource) var memories_index

export(NodePath) var spawn_container
export(NodePath) var gem_container
export(NodePath) var memory_container
export(NodePath) var player_path
export(NodePath) var action_bgm_path
export(NodePath) var surprise_sfx_path

# Endgame, wrong choice, spawn forever
var auto_spawn = false
var last_auto_spawn = 0

func _ready():
	player_info.connect("memory_complete", self, "_on_memory_complete")
	player_info.connect("shadow_despawned", self, "_on_shadow_despawned")
	
	player_info.skills.connect("skill_selected", self, "_on_skill_selected")
	
	# Spawn memory to start the game
	spawn_memory()

func _on_shadow_despawned():
	yield(get_tree(),"idle_frame")
	
	print("Shadow despawned")
	var container = get_node(spawn_container)
	if container.get_child_count() == 0:
		get_node(action_bgm_path).fade_out()
		
		spawn_gem_at(player_info.player_node.get_pickup_spawn_point())

func _on_skill_selected():
	print("Skill selected")
	if get_node(spawn_container).get_child_count() == 0:
		spawn_memory()

func _process(dt):
	last_auto_spawn += dt
	if auto_spawn and last_auto_spawn > 1:
		var angle = rand_range(0, 360)
		var distance = rand_range(10, 20)
		var loc = player_info.player_node.translation + Vector3(cos(deg2rad(angle)) * distance, 0, sin(deg2rad(angle)) * distance )
		spawn_at(loc)
		last_auto_spawn = 0

func spawn_gem_at(loc):
	var gem = preload("res://Actors/SkillGem.tscn").instance()
	gem.translation = loc
	get_node(gem_container).add_child(gem)

func spawn_memory():
	var loc = player_info.player_node.get_pickup_spawn_point()
	var memory = preload("res://Actors/Memory/Memory.tscn").instance()
	memory.memory_data = memories_index.memories[player_info.memories_completed]
	memory.translation = loc
	memory.look_at_node = player_path
	get_node(memory_container).add_child(memory)

func _on_memory_complete(memory):
	if player_info.memories_completed == 1:
		get_node(action_bgm_path).fade_in()
		get_node(surprise_sfx_path).play()
		spawn_first_shadow()
		spawn_gem_at(player_info.player_node.get_first_gem_spawn_point())
	elif player_info.memories_completed == 6:
		var category = player_info.skills.passive_skills[0].category
		if category == "courage":
			spawn_friendly_shadows()
			player_info.complete_game()
			player_info.skills.restart()
			
		if category == "fear":
			get_node(action_bgm_path).fade_in()
			auto_spawn = true
	else:
		get_node(action_bgm_path).fade_in()
		var spawn_count = player_info.memories_completed
		var angle_between = 360 / spawn_count
		var angle = rand_range(0, 360)
		
		for i in range(0, spawn_count):
			angle += rand_range(angle_between - 10, angle_between)
			var distance = rand_range(15, 40)
			var loc = player_info.player_node.translation + Vector3(cos(deg2rad(angle)) * distance, 0, sin(deg2rad(angle)) * distance )
			spawn_at(loc)

func spawn_at(loc):
	var shadow = preload("res://Actors/Shadow/Shadow.tscn").instance()
	var container = get_node(spawn_container)
	container.add_child(shadow)
	shadow.translation = loc

func generate_offset(distance = 1):
	var angle = rand_range(-PI, PI)
	return Vector3(cos(angle) * distance, 0, sin(angle) * distance)
	
func spawn_friendly_shadows():
	var loc = player_info.player_node.get_first_shadow_spawn_point()
	spawn_at(loc)
	loc += generate_offset()
	spawn_at(loc)
	loc += generate_offset()
	spawn_at(loc)
	loc += generate_offset()
	spawn_at(loc)

# First one is special, to orient player
func spawn_first_shadow():
	var loc = player_info.player_node.get_first_shadow_spawn_point()
	spawn_at(loc)
