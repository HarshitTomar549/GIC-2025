extends Sprite2D

@export var strength : float = 20.0 

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var screen_size = get_viewport_rect().size

	var offset = (mouse_pos / screen_size) * 2.0 - Vector2(1, 1)

	position = (offset * strength) + Vector2(960,540)
