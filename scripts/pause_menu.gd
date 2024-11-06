extends CanvasLayer

##Dictates what scenes should not be able to use the pause menu
@export var excluded_scenes = [
	"MainMenu"
]

func _ready():
	visible = false

#region pause menu buttons
func _on_continue_button_pressed():
	unpause()

#Sends the restart signal and unpauses the game
func _on_restart_button_pressed():
	unpause()
	get_tree().reload_current_scene()

func _on_exit_button_pressed():
	get_tree().quit();
#endregion

func _physics_process(delta):
	# NOTE
	# since autoload scripts can be referenced by all scripts in a scene.
	# potentially change it so we just call toggle() instead of checking for inputs here.
	if Input.is_action_just_pressed("pause_menu") && !excluded_scenes.has(get_tree().current_scene.name):
		toggle()

func toggle():
	if get_tree().paused == false:
		pause()
	else:
		unpause()

func pause():
	visible = true
	get_tree().paused = true

func unpause():
	visible = false
	get_tree().paused = false
