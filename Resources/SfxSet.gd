class_name SfxSet
extends Resource

export(Array, Resource) var sounds

func pick_one():
	var idx = floor(rand_range(0, sounds.size()))
	return sounds[idx]
