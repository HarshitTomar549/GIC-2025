extends Panel

@export var death_stats : Label
func _ready() -> void:
	ScoreTracker.death_ui = self
	ScoreTracker.death_stats = death_stats
	self.visible = false
	$Button.connect("pressed", _on_load_game_pressed)
	$Button2.connect("pressed", _on_quit_pressed)

func _process(delta: float) -> void:
	pass
@export var game_scene : String = "res://Main.tscn"

func _on_load_game_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	click()

func _on_quit_pressed():
	click()
	get_tree().quit()

func click():
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_UI_CLICK)
