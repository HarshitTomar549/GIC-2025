extends Area2D

signal rock_picked_up

@export var game_manager: Node
@export var attack_type: String = "default"



func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if game_manager.is_ability_slider_full():
		if body.is_in_group("Player"):
			rock_picked_up.emit()
			
			game_manager.on_rock_pickup()
			
			queue_free()
	
