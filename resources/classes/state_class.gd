extends Node
class_name State
signal Transitioned

var state_parent : Node
var current_input # TODO potentially change this and previous_input to something like, last_direction, direction
var previous_input # see player.gd
var velocity : Vector2 = Vector2.ZERO

func get_direction(input, p_input):
	current_input = input
	previous_input = p_input

func enter():
	pass

func exit():
	pass

func update(_delta : float):
	pass

func physics_update(_delta : float):
	pass

func transition(desired_state : String):
	Transitioned.emit(self, desired_state)
