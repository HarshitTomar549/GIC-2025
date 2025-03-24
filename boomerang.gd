extends Area2D

@export var speed: float = 300.0

var direction: Vector2
var returning: bool = false

@export var game_manager: Node2D

func _ready():
	connect("area_entered", self._on_area_entered)
	
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	$Timer.start(2.0)

func _process(delta):
	if returning:
		var to_origin = (Vector2.ZERO - position).normalized()
		position += to_origin * speed * delta
		
		if position.distance_to(Vector2.ZERO) < 5.0:
			queue_free()
	else:
		position += direction * speed * delta

func _on_timer_timeout():
	returning = true

func _on_area_entered(area: Area2D):
	if area.has_method("take_damage"):
		game_manager.increase_ability_slider(10)
		area.take_damage(100,global_position)
