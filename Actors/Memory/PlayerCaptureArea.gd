extends Area

var captured = false

func capture_player():
	if captured == true:
		return false
	
	captured = true
	get_parent().start_memory()
	return true
