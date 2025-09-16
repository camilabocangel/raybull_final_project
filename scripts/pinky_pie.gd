extends CharacterBody2D

const SPEED = 20.0
const ACCEL = 200.0
@export var hp = 50
var direction = 1
@export var target = Vector2.ZERO
var player_detected = false

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $HitBox

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
		
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += SPEED * delta * direction
	
	if hp <= 0 and animated_sprite.animation != "death":
		animated_sprite.play("death")
		# Don't queue_free here
	
	#player detected
	if player_detected:
		var direction = global_position.direction_to(target).normalized()
		velocity = velocity.move_toward(direction * SPEED, delta * ACCEL)
		move_and_slide()

	move_and_slide()

func _on_animation_finished():
	if animated_sprite.animation == "death":
		queue_free()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	hp -= 10
	print("OUCHHHHHHHH (enemigo)")

func _on_detection_area_area_entered(area: Area2D) -> void:
	player_detected = true 
	target = area.global_position

func _on_detection_area_area_exited(area: Area2D) -> void:
	player_detected = false 
	target = global_position

func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite and animated_sprite.animation == "attack":
		match animated_sprite.frame:
			2, 4:
				hitbox.disabled = false    
			_:
				hitbox.disabled = true
	
