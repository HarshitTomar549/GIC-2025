extends CharacterBody2D

@export var speed: float = 10.0
@onready var player: Node2D = null
@export var damage_cooldown: float = .5
@export var damage: int = 10

var last_damage_time: float = 0.0

@export var stretch_amount := 0.15
@export var squish_amount := 0.1
@export var animation_speed := 5.0

func _ready():
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		
		var angle = direction.angle()
		rotation = angle
		
		var stretch = 1.0 + stretch_amount * sin(Time.get_ticks_msec() * 0.001 * animation_speed)
		var squish = 1.0 - squish_amount * sin(Time.get_ticks_msec() * 0.001 * animation_speed)

		if direction.x != 0:
			scale.x = stretch
			scale.y = squish
		elif direction.y != 0:
			scale.x = squish
			scale.y = stretch

		var collision = move_and_collide(velocity * delta)
		if collision:
			var body = collision.get_collider()
			if body.is_in_group("Player") and (Time.get_ticks_msec() / 1000.0 - last_damage_time) >= damage_cooldown:
				body.take_damage(damage,global_position)
				last_damage_time = Time.get_ticks_msec() / 1000.0
