extends Control

export(Resource) var ui_state

func _ready():
	ui_state.connect("changed", self, "_ui_state_changed")

func _ui_state_changed():
	print("Choose from ", ui_state.available_skill_1, " or ", ui_state.available_skill_2)
	$MarginContainer/VBoxContainer/HBoxContainer/Upgrade1Button.skill = ui_state.available_skill_1
	$MarginContainer/VBoxContainer/HBoxContainer/Upgrade2Button.skill = ui_state.available_skill_2
