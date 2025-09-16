extends Node2D

@onready var player = $Player
@onready var killer_zone = $Killzone

func _process(delta: float) -> void:
	killer_zone.player_fell.connect(_on_player_fell)
	player.death.connect(_on_game_over)
	
func _on_player_fell():
	player.reduce_hp(10)
	
func _on_game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
