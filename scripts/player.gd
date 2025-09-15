extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var SLIDE_SPEED = 250.0
var is_attacking = false
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var slide_timer: Timer = $SlideTimer


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_attacking:
		if not slide_timer.is_stopped():
			slide_timer.stop()
		velocity.y = JUMP_VELOCITY
	

	
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0: 
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	var sliding := not slide_timer.is_stopped()
		
	if is_attacking:
		pass
	else:
		if is_on_floor():
			if sliding:
				animated_sprite.play("slide")
			else:
				if direction == 0:
					if Input.is_action_pressed("crouch") and not is_attacking:
						animated_sprite.play("crouch")
					else:
						animated_sprite.play("idle")
				else:
					animated_sprite.play("run")
		else:
			animated_sprite.play("jump")
		
	
	if direction:
		if sliding:
			velocity.x = direction * SLIDE_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	if Input.is_action_just_pressed("slide") and is_on_floor() and direction != 0 and slide_timer.is_stopped():
		slide_timer.start()
		
	if is_on_floor() and not is_attacking:
		if Input.is_action_pressed("attack1"):
			is_attacking = true
			animated_sprite.play("attack1")
		elif Input.is_action_pressed("attack2"):
			is_attacking = true
			animated_sprite.play("attack2")
		elif Input.is_action_pressed("attack3"):
			is_attacking = true
			animated_sprite.play("attack3")

func _on_SlideTimer_timeout() -> void:
	pass



func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack1" or animated_sprite.animation == "attack2" or animated_sprite.animation == "attack3":
		is_attacking = false
