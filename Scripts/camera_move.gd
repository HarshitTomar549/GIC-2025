extends Node2D

@onready var player = $"../Player/Player"

func _process(delta):
	if player:
		global_position = player.global_position
