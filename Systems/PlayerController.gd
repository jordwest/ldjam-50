extends Node

export(float) var max_speed = 4
export(float) var mouse_sensitivity = 0.01  # radians/pixel
export(Resource) var player_data

var captured_by_memory = false

var velocity = Vector3()

var player: KinematicBody

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()
	player_data.skills.connect("beam_fired", self, "_on_beam_fired")

func _on_beam_fired():
	var pivot: Spatial = player.get_node("Pivot")
	pivot.rotate_x(0.04)
	pivot.rotation.x = clamp(pivot.rotation.x, -1.2, 1.2)

func get_input_dir():
	var input_dir = Vector3()
	# desired move in camera direction
	if Input.is_action_pressed("move_forward"):
		input_dir += -player.global_transform.basis.z
	if Input.is_action_pressed("move_backward"):
		input_dir += player.global_transform.basis.z
	if Input.is_action_pressed("strafe_left"):
		input_dir += -player.global_transform.basis.x
	if Input.is_action_pressed("strafe_right"):
		input_dir += player.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir

func _physics_process(delta):
	if captured_by_memory:
		return

	var desired_velocity = get_input_dir() * max_speed
	
	var movement_skill = player_data.skills.movement_skill
	
	if Input.is_action_just_pressed("movement_modifier"):
		if movement_skill != null:
			if movement_skill.category == "run" and movement_skill.use_skill():
				print("Running")
			elif movement_skill.category == "dash" and movement_skill.use_skill():
				print("Dashing")

	if movement_skill != null and movement_skill.category == "dash" and movement_skill.is_active():
		desired_velocity *= 10
	elif movement_skill != null and movement_skill.category == "run" and movement_skill.is_active():
		desired_velocity *= movement_skill.speed_multiplier

	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = player.move_and_slide(velocity, Vector3.UP, true)
	player.translation.y = 0

func _process(dt):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		activate_primary()

func _unhandled_input(event):
	if event.is_action("ui_cancel") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if captured_by_memory:
			return
		
		print("Mouse moved ", event.relative.x, ", ", event.relative.y)
		player.rotate_y(-event.relative.x * mouse_sensitivity)
		var pivot: Spatial = player.get_node("Pivot")
		pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		pivot.rotation.x = clamp(pivot.rotation.x, -1.2, 1.2)
	
	if event is InputEventMouseButton:
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif event.button_index == BUTTON_LEFT and event.pressed:
			activate_primary()

func activate_primary():
	var skill: Skill = player_data.skills.primary_skill
	if skill != null and skill.use_skill():
		if skill.category == "beam":
			player_data.skills.emit_signal("beam_fired")
		if skill.category == "reject":
			player_data.skills.emit_signal("reject_fired")
