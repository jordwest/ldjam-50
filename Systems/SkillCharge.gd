extends Node

export(Resource) var skills

func _process(delta):
	if skills.dash_count < skills.dash_count_max:
		skills.dash_charge_time += delta
		if skills.dash_charge_time > 2:
			skills.dash_count += 1
			skills.dash_charge_time = skills.dash_charge_time - 2
