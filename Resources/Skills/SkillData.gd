class_name Skill
extends Resource

enum Slot {
	MOVEMENT,
	PRIMARY,
	SECONDARY,
	PASSIVE
}

export(Slot) var slot
export(float) var charge_time
export(float) var max_charges
export(float) var duration

export(String) var title
export(String) var description

export(String) var category
export(int) var level

export(float) var speed_multiplier = 1

var current_charges = 0
var charge = 0
var active_time_remaining = 0

func use_skill():
	if current_charges > 0 and active_time_remaining == 0:
		current_charges -= 1
		active_time_remaining = duration
		return true

	return false

func is_active():
	return active_time_remaining > 0

func charge_skill(dt):
	if active_time_remaining > 0:
		active_time_remaining = max(active_time_remaining - dt, 0)
	
	if current_charges < max_charges:
		charge += dt
		if charge > charge_time:
			charge -= charge_time
			current_charges += 1
	else:
		charge = 0
