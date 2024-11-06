extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

@onready var _animated_sprite = $AnimatedSprite2D

##How far can we go down before we are considered out of stage
## and need to reset the player back to the start [in pixels]
@export var FALL_LIMIT = 2000

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(_delta):
	##for some reason up is down with godot.
	##this places the player back at the start if they fall off.
	if(position.y >= FALL_LIMIT):
		get_tree().reload_current_scene()


#Handles everything for player physics
func _physics_process(delta):
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED;
		#Temporary, we'll change this stuff to a state machine
		_animated_sprite.play("run")
		_animated_sprite.flip_h = true if direction == -1 else false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		_animated_sprite.play("idle")

	move_and_slide()
