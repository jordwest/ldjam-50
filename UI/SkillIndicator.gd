extends Control

export(Resource) var skill

enum Icon {
	DASH, 
	PRIMARY
}

export(Icon) var icon

func _ready():
	if icon == Icon.DASH:
		$HBoxContainer/TextureRect.texture = preload("res://Assets/icons/dash.png")
	else:
		$HBoxContainer/TextureRect.texture = preload("res://Assets/icons/attack.png")

func _process(dt):
	if skill == null:
		return
	
	var container = $HBoxContainer/ChargeIndicators
	var expected_count = skill.max_charges
	
	while container.get_child_count() < expected_count:
		var indicator = preload("res://UI/ChargeIndicator.tscn").instance()
		container.add_child(indicator)
	while container.get_child_count() > expected_count:
		var child = container.get_child(0)
		container.remove_child(child)
		child.queue_free()
	
	for i in range(0, expected_count):
		var child = container.get_child(i)
		if i < skill.current_charges:
			child.charge_level = 1
		elif i == skill.current_charges:
			child.charge_level = skill.charge / skill.charge_time
		else:
			child.charge_level = 0
