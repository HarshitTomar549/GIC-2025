extends Node2D

@onready var player = $"../Player/Player"

func _process(delta):
	if player:
		global_position = player.global_position

@export var shake_strength: float = 0
@export var shake_duration: float = 0

var tween: Tween

func shake():
	if tween:
		tween.kill()

	var start_position = position
	tween = create_tween()

	for i in range(5):
		var offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		tween.tween_property(self, "position", start_position + offset, shake_duration / 5)

	tween.tween_property(self, "position", start_position, shake_duration / 5)
