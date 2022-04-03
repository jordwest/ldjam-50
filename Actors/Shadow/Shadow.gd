extends KinematicBody

export(Resource) var player_events
export(float) var spawn_movement_delay = 0.0
export(float) var speed = 1.0
export(float) var hp = 1

export(Color) var light_color
export(Color) var hit_light_color

var spawning = false

var knockback_vector = Vector3(0, 0, 0)
var knockback_distance = 0

var next_idle_sound = 0

func _ready():
	play_idle_sound()

func play_idle_sound():
	$IdleSound.play_random()
	next_idle_sound = rand_range(2, 4)

func set_eyes(on):
	var eye_mat = $Body/ShadowHeadPivot/ShadowHead/ShadowHead.get_active_material(1)
	if on:
		eye_mat.emission_energy = 1
	else:
		eye_mat.emission_energy = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_events.dead:
		return
	
	next_idle_sound -= delta
	if next_idle_sound <= 0:
		play_idle_sound()
	
	var player_pos = player_events.player_node.global_transform.origin
	$Body/ShadowHeadPivot.look_at(player_pos, Vector3(0, 1, 0))
	
	if spawn_movement_delay:
		spawn_movement_delay = max(0, spawn_movement_delay - delta)
	
	if hp <= 0 and not spawning:
		despawn()

func _physics_process(delta):
	if player_events.dead or player_events.complete:
		return
	
	if spawn_movement_delay == 0 and not spawning:
		var dir_to_player: Vector3 = player_events.player_node.global_transform.origin - self.global_transform.origin
		var vel_to_player: Vector3 = dir_to_player.normalized() * speed
		self.move_and_slide(vel_to_player, Vector3(0, 1, 0))
		
		var collision = get_last_slide_collision()
		if collision != null and collision.collider == player_events.player_node:
			player_events.die()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		var knockback_vel = knockback_vector.normalized() * 30.0
		var travelled_vel = self.move_and_slide(knockback_vel, Vector3(0, 1, 0))
		
		knockback_distance -= travelled_vel.length() * delta
		if knockback_distance <= 0:
			knockback_distance = 0
			knockback_vector = Vector3(0, 0, 0)
		
		self.translation.y = 0

func knockback(dir: Vector3):
	knockback_vector += dir.normalized()
	knockback_distance = dir.length()

func hit(dmg):
	$HitNoise.play()
	$OmniLight.light_color = hit_light_color
	$OmniLight.light_energy = 4
	$HitParticles.emitting = true
	$HitParticles.restart()
	$LightOn.start(0.1)
	hp = max(hp - dmg, 0)

func despawn():
	$AnimationPlayer.play("Despawn")
	$TorsoCollider.disabled = true
	$BaseCollider.disabled = true
	$DeathSound.play_random()
	spawning = true

func despawn_complete():
	print("Shadow despawned, emit signal")
	player_events.emit_signal("shadow_despawned")
	self.queue_free()


func _on_LightOn_timeout():
	$OmniLight.light_color = light_color
	$OmniLight.light_energy = 1
