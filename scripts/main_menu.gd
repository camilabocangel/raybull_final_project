extends Node2D

@onready var play_button = $Play_Button
@onready var map = $TileMap

func _ready() -> void:
	map.set_script(null)

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_texture_button_mouse_entered() -> void:
	play_button.scale = Vector2(0.3, 0.3)

func _on_texture_button_mouse_exited() -> void:
	play_button.scale = Vector2(0.2, 0.2)
