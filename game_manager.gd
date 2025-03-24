extends Node

# Dictionary to keep track of attack types and their counts
var attack_stats = {
	"Spinning Rock": 0,
	"Boomerang Rock": 0,
}


@onready var stats_label = $"../CanvasLayer/Control2/StatsLabel"
@onready var card_ui = $"../CanvasLayer/Control/CardUI"    # UI panel with two card buttons
@onready var card1_button = $"../CanvasLayer/Control/CardUI/Card1Button"
@onready var card2_button = $"../CanvasLayer/Control/CardUI/Card2Button"
@export var ability_slider : Slider
@export var spinner : Node
@export var boomerang_spawner : Node
@export var rock_scene : PackedScene

# Max value for the slider
@export var max_ability_value: float = 100.0
@export var max_ability_value_multiplier: float = 1.5

# Variables to store the chosen attacks
var chosen_attack: String = ""
var waiting_for_choice = false

func _ready() -> void:
	ability_slider.max_value = max_ability_value
	ability_slider.value = max_ability_value
	
	card_ui.visible = false
	

# Called when the player picks up a rock
func on_rock_pickup():
	get_tree().paused = true  # Pause the game
	reset_ability_slider()

	# Choose two random attack types
	var attack_options = attack_stats.keys()
	var choice1 = attack_options[0]
	var choice2 = attack_options[1]

	# Ensure both choices are different
	while choice2 == choice1:
		choice2 = attack_options[randi() % attack_options.size()]

	# Show the card UI and display the choices
	display_cards(choice1, choice2)

	# Wait for the player to choose
	waiting_for_choice = true
	await wait_for_choice()

	# Increment the chosen attack count
	attack_stats[chosen_attack] += 1
	
	# Spawn the chosen attack
	spawn_attack()

	# Resume the game
	get_tree().paused = false

	# Update the UI
	update_stats_ui()

# Display the two random cards
func display_cards(option1: String, option2: String):
	card_ui.visible = true
	card1_button.disabled = false  # Enable buttons
	card2_button.disabled = false

# Handle card button presses
func _on_card1_pressed():
	chosen_attack = "Spinning Rock"
	waiting_for_choice = false
	card_ui.visible = false

func _on_card2_pressed():
	chosen_attack = "Boomerang Rock"
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
