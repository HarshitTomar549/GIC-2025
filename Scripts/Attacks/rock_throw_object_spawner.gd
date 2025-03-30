extends Node2D

@export var boomerang_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var game_manager : Node2D

var timer: float = 0.0

func _process(delta):
	timer += delta
	if timer >= spawn_interval:
		spawn_boomerang()
		timer = 0.0

func spawn_boomerang():
	var boomerang = boomerang_scene.instantiate()
	boomerang.game_manager = game_manager
	add_child(boomerang)
