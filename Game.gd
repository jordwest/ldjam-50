extends Node2D

export(Resource) var ui_state
export(Resource) var player_info

func _ready():
	ui_state.connect("changed", self, "_ui_state_changed")
	player_info.connect("player_died", self, "_on_player_died")
	player_info.connect("game_complete", self, "_on_game_complete")

func _process(delta):
	var paused = get_tree().paused
	var screen = ui_state.screen
	$PauseScreen.visible = get_tree().paused and ui_state.screen == null

func _ui_state_changed():
	$SkillSelector.visible = ui_state.screen == UiState.UiScreen.SKILL_SELECTOR
	$StartScreen.visible = ui_state.screen == UiState.UiScreen.START_SCREEN
	$DeadScreen.visible = ui_state.screen == UiState.UiScreen.GAME_OVER_SCREEN

func _on_player_died():
	ui_state.show_screen(UiState.UiScreen.GAME_OVER_SCREEN)
	$DeadScreen/AnimationPlayer.play("Appear")

func _on_game_complete():
	$GameCompleteOverlay.visible = true
	$GameCompleteOverlay/AnimationPlayer.play("GameOver")
