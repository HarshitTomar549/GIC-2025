extends Node

var attack_stats = {
	"Spinning Rock": 0,
	"Boomerang Rock": 0,
}

@onready var stats_label = $"../CanvasLayer/Control2/StatsLabel"
@onready var card_ui = $"../CanvasLayer/Control/CardUI"
@onready var card1_button = $"../CanvasLayer/Control/CardUI/Card1Button"
@onready var card2_button = $"../CanvasLayer/Control/CardUI/Card2Button"
@export var ability_slider : Slider
@export var spinner : Node
@export var boomerang_spawner : Node
@export var rock_scene : PackedScene

@export var max_ability_value: float = 100.0
@export var max_ability_value_multiplier: float = 1.5

var chosen_attack: String = ""
var waiting_for_choice = false

func _ready() -> void:
	ability_slider.max_value = max_ability_value
	ability_slider.value = max_ability_value
	
	card_ui.visible = false

func on_rock_pickup():
	get_tree().paused = true
	reset_ability_slider()

	var attack_options = attack_stats.keys()
	var choice1 = attack_options[0]
	var choice2 = attack_options[1]

	while choice2 == choice1:
		choice2 = attack_options[randi() % attack_options.size()]

	display_cards(choice1, choice2)

	waiting_for_choice = true
	await wait_for_choice()

	attack_stats[chosen_attack] += 1
	
	spawn_attack()

	get_tree().paused = false

	update_stats_ui()

func display_cards(option1: String, option2: String):
	card_ui.visible = true
	card1_button.disabled = false
	card2_button.disabled = false

func _on_card1_pressed():
	chosen_attack = card1_button.text
	waiting_for_choice = false
	card_ui.visible = false

func _on_card2_pressed():
	chosen_attack = card2_button.text
	waiting_for_choice = false
	card_ui.visible = false

func wait_for_choice():
	while waiting_for_choice:
		await get_tree().process_frame

func spawn_attack():
	if chosen_attack != "":
		print("Spawning: ", chosen_attack)
		if chosen_attack == "Spinning Rock":
			spinner.add_child_with_offset(rock_scene)
		elif chosen_attack == "Boomerang Rock":
			boomerang_spawner.create_child()

func update_stats_ui():
	var stats_text = "Attack Stats:\n"
	for attack in attack_stats:
		stats_text += "%s: %d\n" % [attack, attack_stats[attack]]
	stats_label.text = stats_text

func increase_ability_slider(amount: float):
	ability_slider.value += amount

func reset_ability_slider():
	ability_slider.value = 0
	max_ability_value *= max_ability_value_multiplier
	ability_slider.max_value = max_ability_value

func is_ability_slider_full() -> bool:
	return ability_slider.value >= max_ability_value

func _on_card_1_button_pressed() -> void:
	_on_card1_pressed()
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_UI_CLICK)

func _on_card_2_button_pressed() -> void:
	_on_card2_pressed()
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_UI_CLICK)
