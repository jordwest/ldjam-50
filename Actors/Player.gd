extends KinematicBody

var current_memory = null

export(Resource) var player_events
export(Resource) var ui_state

func _physics_process(delta):
	player_events.skills.charge_skills(delta)
	
	var rc: RayCast = $Pivot/MemoryRayCast
	var collider = rc.get_collider()
	
	if collider != null and collider.has_method("capture_player")  and current_memory == null:
		if collider.capture_player():
			$PlayerController.captured_by_memory = true
			current_memory = collider

func _ready():
	player_events.player_node = self
	player_events.connect("memory_complete", self, "on_memory_complete")
	player_events.skills.connect("beam_fired", self, "_on_beam_fired")
	player_events.skills.connect("reject_fired", self, "_on_reject_fired")
	player_events.connect("game_complete", self, "_on_game_complete")

func _on_game_complete():
	$Confetti.emitting = true

func on_memory_complete(memory):
	current_memory = null
	player_events.memories_completed += 1
	$PlayerController.captured_by_memory = false

func _on_beam_fired():
	print("Beam fired")
	$BeamAudioPlayer.play()
	$Pivot/BeamRayCast.force_raycast_update()
	var collider = $Pivot/BeamRayCast.get_collider()
	
	if collider != null and collider.has_method("hit"):
		collider.hit(1)

func _on_reject_fired():
	print("Reject fired")
	$RejectAudioPlayer.play()
	var effect = preload("res://FX/Weapons/Reject/RejectEffect.tscn").instance()
	self.add_child(effect)
	
	"""
	# Get all hittable objects in area around player
	var bodies = Dictionary()
	
	for angle in range(-30, 30, 1):
		for fraction in range(0, 3):
			$RejectRayCast.rotation.y = deg2rad(angle + (fraction/3))
			$RejectRayCast.force_raycast_update()
			var body: KinematicBody = $RejectRayCast.get_collider()
			if body != null:
				bodies[body.get_rid()] = body
	
	for rid in bodies:
		var body = bodies[rid]
		if body.has_method("hit"):
			print("Hit ", body)
			#body.hit(1)
		if body.has_method("knockback"):
			body.knockback((body.global_transform.origin - self.global_transform.origin).normalized() * 3.0)
	"""

func get_first_shadow_spawn_point():
	return $FirstShadowSpawnPoint.global_transform.origin

func get_pickup_spawn_point():
	return $PickupSpawnLocation.global_transform.origin

func get_first_gem_spawn_point():
	return $FirstGemSpawnLocation.global_transform.origin


