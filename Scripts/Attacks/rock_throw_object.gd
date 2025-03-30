extends Area2D

@export var speed: float = 300.0

var direction: Vector2
@export var game_manager: Node2D

func _ready():
	connect("area_entered", self._on_area_entered)
	
	#picks a random direction to move in
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.start(3)

func _process(delta):
	position += direction * speed * delta

func _on_timer_timeout():
	queue_free()

func _on_area_entered(area: Area2D):
	if area.has_method("take_damage"):
		game_manager.increase_ability_slider(30)
		area.take_damage(100,global_position)
