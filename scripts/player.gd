extends CharacterBody2D

const SPEED = 300.0
const MAX_SPEED = 300.0
const JUMP_VELOCITY = -500.0

var direction : float = 0.0
var previous_direction : float = 0.0

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
	direction = Input.get_axis("move_left", "move_right")
	if direction != 0.0:
		previous_direction = direction
	
	move_and_slide()
