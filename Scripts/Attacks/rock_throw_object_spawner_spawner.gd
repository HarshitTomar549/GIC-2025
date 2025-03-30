extends Node2D

@onready var player = $"../../Player/Player"
@export var game_manager : Node2D
@export var boomerang_spawner : PackedScene

func _process(delta):
	global_position = player.global_position

func create_child():
	var new_child = boomerang_spawner.instantiate()
	new_child.game_manager = game_manager
	
	add_child(new_child)
