extends Area2D  

@export var damage: int = 20  
@export var game_manager : Node2D

func  _ready() -> void:
	connect("area_entered", self._on_area_entered)

func _on_area_entered(area: Area2D):	
	if area.has_method("take_damage"):
		game_manager.increase_ability_slider(10)
		area.take_damage(damage,global_position)
