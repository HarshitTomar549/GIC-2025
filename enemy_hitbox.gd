extends Area2D

@export var max_health: int = 100
var current_health: int

signal health_changed(current_health)
signal enemy_died

@export var health_slider: Slider
@export var hide_timer: Timer
@export var hit_particles : CPUParticles2D

@export var squish_scale: Vector2 = Vector2(1.3, 0.7)
@export var squish_duration: float = 0.2
@export var death_particle: CPUParticles2D

func _ready():
	current_health = max_health
	
	if health_slider:
		health_slider.max_value = max_health
		health_slider.value = current_health
		health_slider.visible = false

	connect("health_changed", _on_health_changed)
	hide_timer.connect("timeout", _on_hide_timer_timeout)

func take_damage(amount: int,hit_source: Vector2):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)

	health_changed.emit(current_health)

	squish()
	spawn_particleS(hit_source)
	AudioManager.create_2d_audio_at_location(global_position,SoundEffect.SOUND_EFFECT_TYPE.ON_ENEMY_HIT)
	if health_slider:
		health_slider.visible = true
		hide_timer.start()

	if current_health <= 0:
		die()

func die():
	death_particle.global_position = global_position
	death_particle.emitting = true
	ScoreTracker.update_score()
	enemy_died.emit()
	AudioManager.create_2d_audio_at_location(global_position,SoundEffect.SOUND_EFFECT_TYPE.ON_ENEMY_DEATH)
	get_parent().queue_free()

func _on_health_changed(new_health: int):
	if health_slider:
		health_slider.value = new_health

func _on_hide_timer_timeout():
	if health_slider:
		health_slider.visible = false

func spawn_particleS(hit_source: Vector2):
	var direction = (hit_source - global_position).normalized()

	var random_angle = randf_range(-0.2, 0.2)
	direction = direction.rotated(random_angle)

	hit_particles.direction = direction
	hit_particles.emitting = true

func squish():
	var tween = create_tween()
	tween.tween_property(get_parent(), "scale", squish_scale, squish_duration * 0.5)
	tween.tween_property(get_parent(), "scale", Vector2(1, 1), squish_duration * 0.5)
