extends Node2D

@export var spin_speed: float = 90.0
@export var offset: float = 50.0 
@onready var player = $"../../Player/Player"
@export var game_manager : Node2D

func _process(delta):
	global_position = player.global_position
	rotation_degrees += spin_speed * delta

func add_child_with_offset(scene: PackedScene):
	var new_child = scene.instantiate()
	new_child.game_manager = game_manager
	
	var child_count = get_child_count()
	new_child.position = Vector2(0, (child_count +1) * offset)

	add_child(new_child)
