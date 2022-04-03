extends Spatial

export(Resource) var player_info
export(Resource) var ui_state
export(Array, Resource) var beam_upgrades
export(Array, Resource) var reject_upgrades
export(Array, Resource) var run_upgrades
export(Array, Resource) var dash_upgrades
export(Array, Resource) var passive_upgrades

func _process(delta):
	$SkillGem.rotate_y(delta)

func find_next_upgrade(current_upgrade, list):
	print("Finding next upgrade for ", current_upgrade, " in ", list)
	var idx = list.find(current_upgrade) + 1
	if idx < list.size():
		return list[idx]
	return null

func choose_skills():
	var s = player_info.skills
	var skill1
	var skill2
	
	if player_info.memories_completed == 5:
		skill1 = preload("res://Resources/Skills/Fear.tres")
		skill2 = preload("res://Resources/Skills/Courage.tres")
	elif s.primary_skill == null:
		# Always choose primary skill first
		skill1 = preload("res://Resources/Skills/Beam0.tres")
		skill2 = preload("res://Resources/Skills/Reject0.tres")
	elif s.movement_skill == null:
		skill1 = preload("res://Resources/Skills/Run0.tres")
		skill2 = preload("res://Resources/Skills/Dash0.tres")
	else:
		var available = []
		if s.primary_skill.category == "beam":
			var upgrade = find_next_upgrade(s.primary_skill, beam_upgrades)
			if upgrade != null:
				available.append(upgrade)
		if s.primary_skill.category == "reject":
			var upgrade = find_next_upgrade(s.primary_skill, reject_upgrades)
			if upgrade != null:
				available.append(upgrade)
		
		if s.movement_skill.category == "run":
			var upgrade = find_next_upgrade(s.movement_skill, run_upgrades)
			if upgrade != null:
				available.append(upgrade)
		if s.movement_skill.category == "dash":
			var upgrade = find_next_upgrade(s.movement_skill, dash_upgrades)
			if upgrade != null:
				available.append(upgrade)
		
		if available.size() > 0:
			skill1 = available[floor(rand_range(0, available.size()))]
			skill2 = available[floor(rand_range(0, available.size()))]
			
			if available.size() > 1:
				while skill1 == skill2:
					# Keep rerolling until another is selected
					skill2 = available[floor(rand_range(0, available.size()))]
	
	ui_state.show_skill_selector(skill1, skill2)

func _on_CollectionArea_body_entered(body):
	if body == player_info.player_node:
		self.queue_free()
		choose_skills()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Spawn":
		$AnimationPlayer.play("Idle")
