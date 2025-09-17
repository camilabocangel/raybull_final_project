extends Node2D

@onready var player = $Player
@onready var killer_zone = $Killzone
@onready var gameManager = $%GameManager
@onready var score = $%GameManager.score
@onready var pink1 = $PinkMonsters/PinkyPie
@onready var pink2 = $PinkMonsters/PinkyPie2
@onready var pink3 = $PinkMonsters/PinkyPie3

func _ready() -> void:	
	killer_zone.player_fell.connect(_on_player_fell)
	player.death.connect(_on_game_over)
	pink1.deathSignal.connect(_on_add_pink_death_score)
	pink2.deathSignal.connect(_on_add_pink_death_score)
	pink3.deathSignal.connect(_on_add_pink_death_score)

func _on_player_fell():
	player.reduce_hp(10)
	GlobalVariables.player_hp = player.hp
	
func _on_game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func _on_add_pink_death_score():
	gameManager.score += 5
	GlobalVariables.score = gameManager.score
