extends Control

export(Resource) var skills

func _ready():
	skills.connect("changed", self, "_on_skills_changed")
	_on_skills_changed()

func _on_skills_changed():
	if skills.primary_skill == null:
		$VBoxContainer/SkillIndicator.visible = false
	else:
		$VBoxContainer/SkillIndicator.visible = true
		$VBoxContainer/SkillIndicator.skill = skills.primary_skill
		
	if skills.movement_skill == null:
		$VBoxContainer/SkillIndicator2.visible = false
	else:
		$VBoxContainer/SkillIndicator2.visible = true
		$VBoxContainer/SkillIndicator2.skill = skills.movement_skill
