class_name Skills
extends Resource

signal beam_fired
signal reject_fired
signal skills_changed
signal skill_selected

export(Resource) var movement_skill
export(Resource) var primary_skill
export(Resource) var secondary_skill
export(Array, Resource) var passive_skills

var dash_count = 1
var dash_count_max = 1
var dash_charge_time = 0

func restart():
	movement_skill = null
	primary_skill = null
	secondary_skill = null
	passive_skills = []
	emit_signal("skills_changed")
	emit_changed()

func get_movement_category():
	if movement_skill == null:
		return null
	return movement_skill.category

func get_primary_category():
	if primary_skill == null:
		return null
	return primary_skill.category

func get_secondary_category():
	if secondary_skill == null:
		return null
	return secondary_skill.category

func add_skill(skill):
	print("Skill is ", skill)
	skill.current_charges = skill.max_charges
	match skill.slot:
		Skill.Slot.MOVEMENT:
			movement_skill = skill
		Skill.Slot.PRIMARY:
			primary_skill = skill
		Skill.Slot.SECONDARY:
			secondary_skill = skill
		Skill.Slot.PASSIVE:
			passive_skills.append(skill)

	emit_signal("skills_changed")
	emit_changed()

func charge_skills(dt):
	if movement_skill != null:
		movement_skill.charge_skill(dt)
	if primary_skill != null:
		primary_skill.charge_skill(dt)
	if secondary_skill != null:
		secondary_skill.charge_skill(dt)
