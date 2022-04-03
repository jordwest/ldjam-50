extends Node2D

export(Resource) var skills
export(Resource) var ui_state

func _ready():
	skills.connect("beam_fired", self, "_on_beam_fired")
	skills.connect("skills_changed", self, "_skills_changed")
	
	ui_state.connect("changed", self, "_ui_changed")

func _on_beam_fired():
	$LaserBeam.fire()

func _skills_changed():
	$Reticule.visible = skills.primary_skill != null
	
func _ui_changed():
	print("UI changed ", ui_state.memory_playing)
	self.visible = !ui_state.memory_playing
