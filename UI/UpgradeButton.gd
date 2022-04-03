extends Button

export(Resource) var skill setget set_skill, get_skill

export(Resource) var ui_state
export(Resource) var skills

export(String) var title_text setget set_title_text, get_title_text
export(String) var info_text setget set_info_text, get_info_text

func set_skill(v):
	skill = v
	if not is_inside_tree(): yield(self, 'ready')
	if v != null:
		set_title_text(v.title)
		set_info_text(v.description)
		var slot_name
		match v.slot:
			Skill.Slot.MOVEMENT:
				slot_name = "MOVEMENT"
			Skill.Slot.PRIMARY:
				slot_name = "PRIMARY"
			Skill.Slot.SECONDARY:
				slot_name = "SECONDARY"
			Skill.Slot.PASSIVE:
				slot_name = "PASSIVE"
		$MarginContainer/VBoxContainer/Slot.text = slot_name

func get_skill():
	return skill

func set_title_text(v):
	if not is_inside_tree(): yield(self, 'ready')
	
	$MarginContainer/VBoxContainer/Title.text = v
func get_title_text():
	return $MarginContainer/VBoxContainer/Title.text

func set_info_text(v):
	if not is_inside_tree(): yield(self, 'ready')
	
	$MarginContainer/VBoxContainer/Info.text = v
func get_info_text():
	return $MarginContainer/VBoxContainer/Info.text

func _on_UpgradeButton_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	ui_state.hide_skill_selector()
	print("Pressed skill ", skill)
	skills.add_skill(skill)
	skills.emit_signal("skill_selected")
