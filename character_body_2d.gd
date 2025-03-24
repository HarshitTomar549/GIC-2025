extends CharacterBody2D

@export var speed: float = 30.0
@export var acceleration: float = 800.0
@export var friction: float = 600.0

@export var knockback_strength: float = 50
@export var knockback_duration: float = 0.2
var knockback_vector: Vector2 = Vector2.ZERO
var knockback_time: float = 0.0

@export var sway_amount: float = 5.0
@export var sway_speed: float = 5.0

var sway_timer = 0.0

@export var max_health: int = 100
var current_health: int

@export var health_slider: Slider  
@onready var death_UI = $CanvasLayer/Control/deathUI

var min_bound = Vector2(-400, -400)
var max_bound = Vector2(400, 400)

@export var squish_scale: Vector2 = Vector2(1.2, 0.8)
@export var squish_duration: float = 0.2

@onready var camera:Camera2D

@onready var player: Node2D = null

@export var hit_particles : CPUParticles2D

func _process(delta: float) -> void:
	health_slider.get_parent().get_parent().global_position = global_position

func _ready():
	camera = get_parent().get_parent().get_node("Camera2D")
	print(death_UI)
	current_health = max_health
	health_slider.max_value = max_health
	health_slider.value = current_health

func _physics_process(delta: float) -> void:
	if knockback_time > 0.0:
		velocity = knockback_vector
		knockback_time -= delta
	else:
		var input_vector = Vector2.ZERO

		input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
		input_vector = input_vector.normalized()

		if input_vector != Vector2.ZERO:
			velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
			sway_timer += delta * sway_speed
			rotation_degrees = sin(sway_timer) * sway_amount
		else:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			sway_timer = 0.0
			rotation_degrees = lerp(rotation_degrees, 0.0, 0.1)

	move_and_slide()

	global_position.x = clamp(global_position.x, min_bound.x, max_bound.x)
	global_position.y = clamp(global_position.y, min_bound.y, max_bound.y)

func take_damage(amount: int, knockback_source: Vector2):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)

	print("Player Health: ", current_health)

	apply_knockback(knockback_source)
	spawn_particleS(knockback_source)
	camera.shake()
	squish()
	flash()
	AudioManager.create_2d_audio_at_location(global_position,SoundEffect.SOUND_EFFECT_TYPE.ON_PLAYER_DAMAGE)

	if health_slider:
		health_slider.value = current_health

	if current_health <= 0:
		get_tree().paused = true
		ScoreTracker.death_ui.visible = true
		ScoreTracker.death()
		print("Player Died!")
	else :
		freeze_game()

func apply_knockback(source_position: Vector2):
	knockback_vector = (global_position - source_position).normalized() * knockback_strength
	knockback_time = knockback_duration

func squish():
	var tween = create_tween()
	tween.tween_property(self, "scale", squish_scale, squish_duration * 0.5)
	tween.tween_property(self, "scale", Vector2(1, 1), squish_duration * 0.5)

func _on_hide_timer_timeout():
	if health_slider:
		health_slider.visible = false

func spawn_particleS(hit_source: Vector2):
	var direction = (hit_source - global_position).normalized()

	var random_angle = randf_range(-0.2, 0.2)
	direction = direction.rotated(random_angle)

	hit_particles.direction = direction
	hit_particles.emitting = true

@export var mat : ShaderMaterial

func flash(duration: float = 0.2, strength: float = 1.0):
	var tween := get_tree().create_tween()
	mat.set("shader_parameter/flash_strength", strength)
	
	tween.tween_property(mat, "shader_parameter/flash_strength", 0.0, duration)
	await tween.finished

func freeze_game(duration: float = 0.1):
	get_tree().paused = true
	await get_tree().create_timer(duration).timeout
	get_tree().paused = false
