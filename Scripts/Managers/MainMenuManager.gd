extends CanvasGroup

@export var game_scene : PackedScene

func _ready():
	$Button.connect("pressed", _on_load_game_pressed)
	$Button2.connect("pressed", _on_quit_pressed)

func _on_load_game_pressed():
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_UI_CLICK)
	get_tree().change_scene_to_packed(game_scene)

func _on_quit_pressed():
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_UI_CLICK)
	get_tree().quit()
	
