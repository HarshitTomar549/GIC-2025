extends CanvasGroup

@export var game_scene : String = "res://Main.tscn"  # Path to your game scene

func _ready():
	$Button.connect("pressed", _on_load_game_pressed)
	$Button2.connect("pressed", _on_quit_pressed)

func _on_load_game_pressed():
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_UI_CLICK)
	if ResourceLoader.exists(game_scene):
		get_tree().change_scene_to_file(game_scene)
	else:
		print("Error: Scene not found!")

func _on_quit_pressed():
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_UI_CLICK)
	get_tree().quit()
	
