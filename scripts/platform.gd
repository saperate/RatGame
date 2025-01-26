@tool #used to run while editor is running
extends Node

@export_enum("GRASS", "ICE") var type: String = "GRASS";

var types_dict = {
	"GRASS": {
		"friction": .75, # 1 means friction equal to the movement, < 1 = less
		"rect": Rect2( # Coordinates for the texture
			16.193,0, # X and Y
			31.863,10.156 # Width and Height
		)
	},
	"ICE": {
		"friction": 0.1,
		"rect": Rect2(
			16.193,48.123,
			31.863,10.156
		)
	}
}

func _ready():
	if(has_node("PlatformSprite")):
		var sprite : Sprite2D = get_node("PlatformSprite")
		sprite.region_rect = types_dict[type]["rect"];

#runs in both editor AND game, use editor hint if you dont want that
func _process(delta):
	# We only really need to constantly check in the editor,
	# Idk why it would change while playing
	if(Engine.is_editor_hint() and has_node("PlatformSprite")):
		var sprite : Sprite2D = get_node("PlatformSprite")
		sprite.region_rect = types_dict[type]["rect"];

func get_friction():
	return types_dict[type]["friction"];
