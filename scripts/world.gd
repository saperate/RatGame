extends Node2D

@onready var pause_menu = $SceneLabelContainer/PauseMenu
var paused = false;


func _input(ev):
	if Input.is_action_just_pressed("pause_menu"):
		pause();

func pause():
	if paused:
		pause_menu.hide();
		Engine.time_scale = 1
	else:
		pause_menu.show();
		Engine.time_scale = 0
	paused = !paused


func _on_pause_menu_continue():
	pause();

func _on_pause_menu_restart():
	get_tree().reload_current_scene();
