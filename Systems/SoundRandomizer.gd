extends AudioStreamPlayer3D

export(Resource) var sfx_set

func play_random():
	var sound = sfx_set.pick_one()
	sound.loop = false
	self.stream = sound
	self.play()
