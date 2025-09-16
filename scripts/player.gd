extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var SLIDE_SPEED = 250.0
var is_attacking = false

signal death

var jumps = 2
@export var hp = 100
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $HitBox
@onready var hurtbox: Area2D = $HurtBox
@onready var slide_timer: Timer = $SlideTimer
@onready var collision_shape_right: CollisionShape2D = $Marker2D/HitBox/CollisionShapeRight
@onready var collision_shape_left: CollisionShape2D = $Marker2D/HitBox/CollisionShapeLeft

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and not is_attacking and jumps > 1:
		jumps -= 1
		if not slide_timer.is_stopped():
			slide_timer.stop()
		velocity.y = JUMP_VELOCITY
		
	if is_on_floor():
			jumps = 2
	
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
					if Input.is_action_pressed("crouch"):
						animated_sprite.play("crouch")
					else:
						animated_sprite.play("idle")
				else:
					animated_sprite.play("run")
		else:
			if jumps == 0:
				animated_sprite.play("fall")
			elif jumps == 1:
				animated_sprite.play("jump2")
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
			if not animated_sprite.flip_h:
				collision_shape_right.disabled = false
			else:
				collision_shape_left.disabled = false
		elif Input.is_action_pressed("attack2"):
			is_attacking = true
			animated_sprite.play("attack2")
			if not animated_sprite.flip_h:
				collision_shape_right.disabled = false
			else:
				collision_shape_left.disabled = false
		elif Input.is_action_pressed("attack3"):
			is_attacking = true
			animated_sprite.play("attack3")
			if not animated_sprite.flip_h:
				collision_shape_right.disabled = false
			else:
				collision_shape_left.disabled = false

func _on_SlideTimer_timeout() -> void:
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack1" or animated_sprite.animation == "attack2" or animated_sprite.animation == "attack3":
		collision_shape_right.disabled = true
		collision_shape_left.disabled = true
		is_attacking = false

func _on_hurt_box_area_entered(area: Area2D) -> void:
	hp -= 10
	print("OUCH (Player)")

func _process(delta: float) -> void:
	if hp <= 0:
		death.emit()
	
func reduce_hp(damage: int):
	hp -= damage
	print("PLayer HP: " + str(hp))
