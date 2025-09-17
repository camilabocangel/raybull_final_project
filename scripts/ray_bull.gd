extends CharacterBody2D


const SPEED = 20
const MAX_SPEED = 80
const ACCEL = 100
@export var hp = 50
var direction = 1
@export var target = Vector2.ZERO
var player_detected = false

signal deathSignal

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $HitBox
@onready var collision_shape_left: CollisionShape2D = $HitBox/CollisionShapeLeft
@onready var collision_shape_right: CollisionShape2D = $HitBox/CollisionShapeRight
@onready var detection_area: Area2D = $DetectionArea 



func _ready() -> void:
	target = global_position

func _physics_process(delta: float) -> void:
	if not animated_sprite:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	velocity.x = 0
	
	#player detected - follow player
	if player_detected:
		var overlaps = detection_area.get_overlapping_areas()
		if overlaps.size() > 0:
			var player = overlaps[0]
			target = player.global_position

		var directions = global_position.direction_to(target).normalized()
		velocity.x = directions.x * MAX_SPEED
		
		if directions.x > 0:
			animated_sprite.flip_h = false
			direction = 1 
		elif directions.x < 0:
			animated_sprite.flip_h = true
			direction = -1 
	
	move_and_slide()
	
func _on_hurt_box_area_entered(area: Area2D) -> void:
	hp -= 10
	print("OUCHHHHHHHH (Bull)")
	if hp <= 0 and animated_sprite.animation != "death":
		animated_sprite.play("death")
		deathSignal.emit()

func _on_detection_area_area_entered(area: Area2D) -> void:
	player_detected = true 
	animated_sprite.play("attack")

func _on_detection_area_area_exited(area: Area2D) -> void:
	player_detected = false 
	target = global_position
	animated_sprite.play("run")


func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.
