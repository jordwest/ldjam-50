extends Spatial

export(NodePath) var look_at_node
export(float) var length = 1.0

export(Resource) var memory_data

export(Resource) var player_events
export(Resource) var ui_state

var time_elapsed = 0
var fading_out = false
var skipped = false

func _ready():
	set_memory_image(memory_data.image_sequence[0])
	$ScreenPivot/MemoryScreen.get_active_material(0).set_shader_param("alpha", 1.0)

func set_memory_image(img):
	$ScreenPivot/MemoryScreen.get_active_material(0).set_shader_param("image", img)

func _process(dt):
	var target = get_node(look_at_node)
	var target_pos = target.global_transform.origin
	target_pos.y = 0
	$ScreenPivot.look_at(target_pos, Vector3(0, 1, 0))
	$ScreenPivot.rotation_degrees.y += 180
	$ScreenPivot.rotation_degrees.x = 0
	if $AudioStreamPlayer.playing:
		time_elapsed += dt
		var frame = floor(time_elapsed * memory_data.fps)
		if frame >= memory_data.image_sequence.size() - (3 * memory_data.fps):
			frame = min(frame, memory_data.image_sequence.size() - 1)
			fade_out()
		set_memory_image(memory_data.image_sequence[frame])
		
		if (Input.is_action_just_pressed("ui_accept")):
			skip()

func start_memory():
	$TweenMemoryActivation.interpolate_property($ScreenPivot/MemoryScreen, "scale", Vector3(1, 1, 1), Vector3(2, 2, 2), 0.5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$TweenMemoryActivation.interpolate_property($ScreenPivot/MemoryScreen.get_active_material(0), "shader_param/fill_progress", 0, 1, 0.5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$TweenMemoryActivation.start()
	$SpotLight.visible = false
	ui_state.set_memory_playing(true)
	
	time_elapsed = 0
	$AudioStreamPlayer.stream = memory_data.audio
	$AudioStreamPlayer.stream.loop = false
	$AudioStreamPlayer.play()

func skip():
	fade_out(0.5)
	skipped = true
	$AudioStreamPlayer.stop()

func fade_out(speed = 3):
	if not fading_out:
		print("Fade out")
		fading_out = true
		#$TweenMemoryActivation.interpolate_property($ScreenPivot/MemoryScreen, "scale", Vector3(2, 2, 2), Vector3(1, 1, 1), 0.5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		$TweenMemoryActivation.interpolate_property($ScreenPivot/MemoryScreen.get_active_material(0), "shader_param/alpha", 1, 0, speed, Tween.TRANS_LINEAR)
		$TweenMemoryActivation.start()

func _on_AudioStreamPlayer_finished():
	if skipped:
		complete()
	else:
		queue_free()
	
func complete():
	ui_state.set_memory_playing(false)
	player_events.emit_signal("memory_complete", self)
	if $AudioStreamPlayer.playing == false:
		queue_free()

func _on_TweenMemoryActivation_tween_completed(object, key):
	print("done", fading_out)
	if fading_out:
		complete()
