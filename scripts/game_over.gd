extends Node2D

@onready var replay_button = $Replay_Button
@onready var menu_button = $Menu_Button

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_menu_button_mouse_entered() -> void:
	menu_button.scale = Vector2(0.9, 0.9)
	menu_button.modulate = Color(1.2, 1, 0, 1)

func _on_menu_button_mouse_exited() -> void:
	menu_button.scale = Vector2(0.8, 0.8)
	menu_button.modulate = Color(1, 1, 1, 1)

func _on_replay_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_replay_button_mouse_entered() -> void:
	replay_button.scale = Vector2(0.9, 0.9)
	replay_button.modulate = Color(1.2, 1, 0, 1)

func _on_replay_button_mouse_exited() -> void:
	replay_button.scale = Vector2(0.8, 0.8)
	replay_button.modulate = Color(1, 1, 1, 1)
