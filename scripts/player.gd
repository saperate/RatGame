extends CharacterBody2D

const SPEED = 300.0
const MAX_SPEED = 300.0
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
	var direction = Input.get_axis("move_left", "move_right")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY;
		# Rudimentary wall jumping that only works when the platform
		# is on the left of the player. TODO generalise this for all walls
		# could probably get the direction we want by substracting our pos
		# with the wall's 
		# TODO possibly make a check that a wall is jumpable too
		elif is_on_wall_only():
			if(direction == 1):
				velocity.y = JUMP_VELOCITY * 1.25;
				velocity.x = SPEED ;
				position.x += 50;
			else:
				position.x += 10
	elif is_on_wall_only():
		velocity.y = 0;
		_animated_sprite.play("idle");
		return;
	

	
	if direction:
		var modded_max_speed = calc_max_speed();
		velocity.x = clamp(
			velocity.x + direction * SPEED * (calc_speed_modifier()), 
			-modded_max_speed, modded_max_speed
		);
		#Temporary, we'll change this stuff to a state machine
		_animated_sprite.play("run")
		_animated_sprite.flip_h = true if direction == -1 else false
	else:
		velocity.x += velocity.x * (calc_friction_modifier(1) - 1);
		_animated_sprite.play("idle")
	
	move_and_slide()


##TODO move all this into the platform script so we can use it with other entities
func calc_max_speed():
	var speed_modifer = 1;
	
	if(Input.is_action_pressed("shift")):
		speed_modifer *= 1.5;
	
	if((Time.get_ticks_msec()/250) % 2 == 0):#simulates steps from the player
		speed_modifer *= calc_step_modifier(false);#pause
	else:
		speed_modifer *= calc_step_modifier(true);#step
	
	return MAX_SPEED * speed_modifer;


func calc_speed_modifier():
	var speed_modifer = 1;
	
	speed_modifer = 1 - calc_friction_modifier(1);
	
	return speed_modifer;

func calc_friction_modifier(speed_modifer: float):
	if(get_slide_collision_count() > 0):
		var collision = get_slide_collision(0);
		if(collision != null and collision.get_collider().has_method("get_friction")):
			speed_modifer -= speed_modifer * collision.get_collider().get_friction();
		return speed_modifer;
	else : # remove this if you want to not be able to move in the air
		return 0;

func calc_step_modifier(step: bool):
	if(get_slide_collision_count() > 0):
		var collision = get_slide_collision(0);
		if(collision != null and collision.get_collider().has_method("get_step_modifier")):
			return collision.get_collider().get_step_modifier(step)
	return 1;
