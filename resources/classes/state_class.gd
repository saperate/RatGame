extends Node
class_name State
signal Transitioned

var state_parent : Node

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
