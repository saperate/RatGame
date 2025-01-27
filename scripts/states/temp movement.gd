extends State

func enter():
	pass

func exit():
	pass

func update(_delta):
	pass

func physics_update(delta):
	
	# Add the gravity.
	if not state_parent.is_on_floor():
		state_parent.velocity.y += state_parent.gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if state_parent.is_on_floor():
			state_parent.velocity.y = state_parent.JUMP_VELOCITY;
		# Rudimentary wall jumping that only works when the platform
		# is on the left of the player. TODO generalise this for all walls
		# could probably get the direction we want by substracting our pos
		# with the wall's 
		# TODO possibly make a check that a wall is jumpable too
		elif state_parent.is_on_wall_only():
			if(state_parent.direction == 1):
				state_parent.velocity.y = state_parent.JUMP_VELOCITY * 1.25;
				state_parent.velocity.x = state_parent.SPEED ;
				state_parent.position.x += 50;
			else:
				state_parent.position.x += 10
	elif state_parent.is_on_wall_only():
		state_parent.velocity.y = 0;
		state_parent._animated_sprite.play("idle");
		return;
	

	
	if state_parent.direction:
		var modded_max_speed = calc_max_speed();
		state_parent.velocity.x = clamp(
			state_parent.velocity.x + state_parent.direction * state_parent.SPEED * (calc_speed_modifier()), 
			-modded_max_speed, modded_max_speed
		);
		#Temporary, we'll change this stuff to a state machine
		state_parent._animated_sprite.play("run")
		state_parent._animated_sprite.flip_h = true if state_parent.direction == -1 else false
	else:
		state_parent.velocity.x += state_parent.velocity.x * (calc_friction_modifier(1) - 1);
		state_parent._animated_sprite.play("idle")


##TODO move all this into the platform script so we can use it with other entities
func calc_max_speed():
	var speed_modifer = 1;
	
	if(Input.is_action_pressed("shift")):
		speed_modifer *= 1.5;
	
	if((Time.get_ticks_msec()/250) % 2 == 0):#simulates steps from the player
		speed_modifer *= calc_step_modifier(false);#pause
	else:
		speed_modifer *= calc_step_modifier(true);#step
	
	return state_parent.MAX_SPEED * speed_modifer;


func calc_speed_modifier():
	var speed_modifer = 1;
	
	speed_modifer = 1 - calc_friction_modifier(1);
	
	return speed_modifer;

func calc_friction_modifier(speed_modifer: float):
	if(state_parent.get_slide_collision_count() > 0):
		var collision = state_parent.get_slide_collision(0);
		if(collision != null and collision.get_collider().has_method("get_friction")):
			speed_modifer -= speed_modifer * collision.get_collider().get_friction();
		return speed_modifer;
	else : # remove this if you want to not be able to move in the air
		return 0;

func calc_step_modifier(step: bool):
	if(state_parent.get_slide_collision_count() > 0):
		var collision = state_parent.get_slide_collision(0);
		if(collision != null and collision.get_collider().has_method("get_step_modifier")):
			return collision.get_collider().get_step_modifier(step)
	return 1;
