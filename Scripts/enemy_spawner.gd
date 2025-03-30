extends Node2D

@export var initial_spawn_rate: float = 2.0
@export var spawn_rate_increase: float = 0.95
@export var min_spawn_rate: float = 0.3
@export var enemy_scene: PackedScene
@export var camera_padding: float = 5.0

@onready var camera: Camera2D = get_viewport().get_camera_2d()

var current_spawn_rate: float
var timer: float = 0.0

func _ready():
	current_spawn_rate = initial_spawn_rate

func _process(delta):
	timer += delta

	if timer >= current_spawn_rate:
		spawn_enemy()
		timer = 0.0

		current_spawn_rate *= spawn_rate_increase
		current_spawn_rate = max(current_spawn_rate, min_spawn_rate)

func spawn_enemy():
	var cam_pos = camera.global_position
	var cam_size = Vector2(
		get_viewport_rect().size.x / camera.zoom.x,
		get_viewport_rect().size.y / camera.zoom.y
	)

	var spawn_position = get_spawn_position(cam_pos, cam_size)
	
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.global_position = spawn_position
	add_child(enemy_instance)

func get_spawn_position(cam_pos: Vector2, cam_size: Vector2) -> Vector2:
	var spawn_position: Vector2

	var x_range_outside = camera_padding + cam_size.x / 2
	var y_range_outside = camera_padding + cam_size.y / 2

	if randf() < 0.5:
		var x_pos = cam_pos.x + (x_range_outside if randf() < 0.5 else -x_range_outside)
		var y_pos = randf_range(cam_pos.y - cam_size.y / 2, cam_pos.y + cam_size.y / 2)
		spawn_position = Vector2(x_pos, y_pos)
	else:
		var y_pos = cam_pos.y + (y_range_outside if randf() < 0.5 else -y_range_outside)
		var x_pos = randf_range(cam_pos.x - cam_size.x / 2, cam_pos.x + cam_size.x / 2)
		spawn_position = Vector2(x_pos, y_pos)

	return spawn_position
