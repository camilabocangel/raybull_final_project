extends CharacterBody2D

const SPEED = 20
const MAX_SPEED = 80
const ACCEL = 100
@export var hp = 50
var direction = 1
@export var target = Vector2.ZERO
var player_detected = false

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $HitBox
@onready var collision_shape_right: CollisionShape2D = $Marker2D/HitBox/CollisionShapeRight
@onready var collision_shape_left: CollisionShape2D = $Marker2D/HitBox/CollisionShapeLeft
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

func _ready() -> void:
	target = global_position
	# Connect the animation finished signal
	animated_sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	if not animated_sprite:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if hp <= 0 and animated_sprite.animation != "death":
		animated_sprite.play("death")
		death_sound.play()
	
	# Reset velocity each frame to prevent accumulation
	velocity.x = 0
	
	#player detected - follow player
	if player_detected:
		var directions = global_position.direction_to(target).normalized()
		velocity.x = directions.x * MAX_SPEED
		
		# Flip sprite based on movement direction
		if directions.x > 0:
			animated_sprite.flip_h = false
			direction = 1  # ADD THIS LINE
		elif directions.x < 0:
			animated_sprite.flip_h = true
			direction = -1  # ADD THIS LINE
		
	else:
		# Normal patrol behavior
		if ray_cast_right.is_colliding():
			direction = -1
			animated_sprite.flip_h = true
		if ray_cast_left.is_colliding():
			direction = 1
			animated_sprite.flip_h = false
		
		velocity.x = direction * SPEED
	
	# MOVE THIS OUTSIDE THE IF/ELSE - CALL ONLY ONCE
	move_and_slide()
		


func _on_animation_finished():
	if animated_sprite.animation == "attack":
		collision_shape_right.disabled = true
		collision_shape_left.disabled = true
	if animated_sprite.animation == "death":
		queue_free()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	hp -= 10
	print("OUCHHHHHHHH (enemigo)")

func _on_detection_area_area_entered(area: Area2D) -> void:
	player_detected = true 
	target = area.global_position
	animated_sprite.play("run")

func _on_detection_area_area_exited(area: Area2D) -> void:
	player_detected = false 
	target = global_position
	animated_sprite.play("walk")
