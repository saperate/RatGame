extends Control

signal on_continue
signal on_restart

func _on_continue_button_pressed():
	on_continue.emit();

func _on_exit_button_pressed():
	get_tree().quit();

#Sends the restart signal and the continue signal to unpause the game
func _on_restart_button_pressed():
	on_restart.emit();
	on_continue.emit();
