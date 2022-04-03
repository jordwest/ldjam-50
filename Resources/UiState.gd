class_name UiState
extends Resource

enum UiScreen {
	SKILL_SELECTOR,
	START_SCREEN,
	GAME_OVER_SCREEN
}

export(Resource) var available_skill_1
export(Resource) var available_skill_2

var screen = UiScreen.START_SCREEN
var memory_playing

func restart():
	screen = UiScreen.START_SCREEN
	memory_playing = null

func set_memory_playing(v):
	print("Memory playing set to ", v)
	memory_playing = v
	emit_changed()

func get_memory_playing():
	return memory_playing

func show_skill_selector(skill1, skill2):
	available_skill_1 = skill1
	available_skill_2 = skill2
	screen = UiScreen.SKILL_SELECTOR
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	emit_changed()

func show_screen(s):
	screen = s
	emit_changed()

func hide_skill_selector():
	screen = null
	emit_changed()

func hide_ui_screen():
	screen = null
	emit_changed()
