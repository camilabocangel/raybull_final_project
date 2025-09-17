extends Area2D

signal player_fell

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	timer.start()

func _on_timer_timeout() -> void:
	player_fell.emit()
	if GlobalVariables.player_alive:
		get_tree().reload_current_scene()
