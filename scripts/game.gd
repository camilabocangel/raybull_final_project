extends Node2D

@onready var player = $Player

func _process(delta: float) -> void:
	player.death.connect(_on_game_over)
