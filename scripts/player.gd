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
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = clamp(velocity.x + direction * SPEED, -MAX_SPEED, MAX_SPEED) * calc_speed_modifier();
		#Temporary, we'll change this stuff to a state machine
		_animated_sprite.play("run")
		_animated_sprite.flip_h = true if direction == -1 else false
	else:
		velocity.x += velocity.x * (calc_friction_modifier(1) - 1);
		_animated_sprite.play("idle")

	move_and_slide()

# This is called AFTER we clamp the speed
func calc_speed_modifier():
	var speed_modifer = 1;
	
	if(Input.is_action_pressed("shift")):
		speed_modifer *= 1.5;
	
	#we could have smth here for a slowness modifier (ex: in a swamp)
	#could possibly use the friction value, but it would need tweaking

	return speed_modifer;

func calc_friction_modifier(speed_modifer: float):
	if(get_slide_collision_count() > 0):
		var friction_modifier = 0;
		# doubt we'll ever get more than 1, but just in case
		for i in get_slide_collision_count():
			var collision = get_slide_collision(0);
			if(collision != null and collision.get_collider().has_method("get_friction")):
				friction_modifier += collision.get_collider().get_friction();
				if(collision.get_collider().get_friction() == 0):
					print("ice");
		speed_modifer -= speed_modifer * friction_modifier / get_slide_collision_count();
	return speed_modifer;
