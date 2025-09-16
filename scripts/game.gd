extends Node2D

@onready var player = $Player

func _process(delta: float) -> void:
	player.death.connect(_on_game_over)
	
func _on_game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
