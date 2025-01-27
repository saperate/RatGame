extends Node
class_name StateManager
# tutorial that i followed: https://www.youtube.com/watch?v=ow_Lum-Agbs
@export var state_parent : CharacterBody2D
@export var initial_state : State

var current_state : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_parent = state_parent
			child.Transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state


func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)


func on_child_transition(state, new_state_name):
	if state != current_state:
		print("ERROR: invald previous state passed through the signal")
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print("ERROR: invalid new_state or new_state_name")
		return
	
	if current_state:
		current_state.exit()
	
	current_state = new_state
	new_state.enter()
	
	#print("successful state change")
