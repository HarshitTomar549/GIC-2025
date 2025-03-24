extends Node

var enemies_defeated: int = 0
var death_ui : Panel
var death_stats : Label

var timeSurvived = 0

func _process(delta: float) -> void:
	timeSurvived += delta

func update_score():
	enemies_defeated += 1

func death():
	death_stats.text = ("Enemies Killed: " + str(enemies_defeated) +"
	Time: " + str(timeSurvived))
