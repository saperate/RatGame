extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

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
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
