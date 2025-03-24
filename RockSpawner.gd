extends Node2D

@export var rock_scene: PackedScene 
@export var spawn_interval: float = 2.0
@export var max_rocks: int = 20         
@export var game_manager: Node


var rocks: Array = []
var timer: float = 0.0

func _process(delta):
	timer += delta
	
	if timer >= spawn_interval and rocks.size() < max_rocks:
		spawn_rock()
		timer = 0.0

	rocks = rocks.filter(func(rock): return is_instance_valid(rock))

func spawn_rock():
	var spawn_position = get_random_spawn_position()
	
	var rock = rock_scene.instantiate()
	rock.global_position = spawn_position
	add_child(rock)
	
	rocks.append(rock)
	rock.game_manager= game_manager
	rock.attack_type = "AOE"

func get_random_spawn_position() -> Vector2:
	var camera = get_viewport().get_camera_2d()
	if camera == null:
		return Vector2.ZERO

	var cam_pos = camera.global_position
	var cam_size = Vector2(
		get_viewport_rect().size.x / camera.zoom.x,
		get_viewport_rect().size.y / camera.zoom.y)
	
	var x = multi_range_random(
		cam_pos.x + (cam_size.x * 0.5), cam_pos.x + ((cam_size.x + 40) * 0.5),
		cam_pos.x - (cam_size.x * 0.5), cam_pos.x - ((cam_size.x + 50) * 0.5)
	)
	var y = multi_range_random(
		cam_pos.y + (cam_size.y * 0.5), cam_pos.y + ((cam_size.y + 40) * 0.5),
		cam_pos.y - (cam_size.y * 0.5), cam_pos.y - ((cam_size.y + 50) * 0.5)
	)
	
	return Vector2(x, y)

func multi_range_random(min1: float, max1: float, min2: float, max2: float) -> float:
	if randf() < 0.5:
		return randf_range(min1, max1)
	else:
		return randf_range(min2, max2)
