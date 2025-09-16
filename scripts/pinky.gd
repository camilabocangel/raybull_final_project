extends Node2D
const SPEED = 20
var direcion = 1
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $HitBox
@onready var hurt_box: Area2D = $HurtBox

var player


func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direcion = -1
		animated_sprite.flip_h = true 
	if ray_cast_left.is_colliding():
		direcion = 1
		animated_sprite.flip_h = false
	position.x += direcion * SPEED * delta
	
	
