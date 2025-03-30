extends Node2D

@export var rotate_angle : float = 45.0 
@export var rotate_speed : float = 1.0  

func _ready():
	animate()

func animate():
	var tween := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "rotation_degrees", rotate_angle, rotate_speed)
	tween.tween_property(self, "rotation_degrees", -rotate_angle, rotate_speed)
