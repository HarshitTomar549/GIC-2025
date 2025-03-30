extends Panel

@export var stats_label : Label

func _ready() -> void:
	ScoreTracker.death_ui = self
	ScoreTracker.death_stats = stats_label
	self.visible = false
	
	$ResetButton.connect("pressed", _on_rest_game_pressed)
	$ExitButton.connect("pressed", _on_quit_pressed)

func _process(delta: float) -> void:
	pass

#continues the game, reloads the scene, resets score and plays click sound
func _on_rest_game_pressed(): 
	get_tree().paused = false
	get_tree().reload_current_scene()
	ScoreTracker.reset_score()
	_play_click_sound()

func _on_quit_pressed():
	_play_click_sound()
	get_tree().quit()

func _play_click_sound():
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_UI_CLICK)
