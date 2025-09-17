extends Node

@export var score = 0
@onready var score_label: Label = $"../Player/ScoreLabel"

func add_point():
	score += 1
	GlobalVariables.score = score
	
func _process(delta: float) -> void:
	score_label.text = "Score: " + str(score)
