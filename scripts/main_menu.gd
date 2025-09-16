extends Node2D

@onready var play_button = $Play_Button

func _on_texture_button_pressed() -> void:
	GlobalVariables.player_hp = 100
	GlobalVariables.score = 0
	GlobalVariables.player_alive = true

	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_texture_button_mouse_entered() -> void:
	play_button.scale = Vector2(0.9, 0.9)
	play_button.modulate = Color(1.2, 1, 0, 1)

func _on_texture_button_mouse_exited() -> void:
	play_button.scale = Vector2(0.8, 0.8)
	play_button.modulate = Color(1, 1, 1, 1)
