extends TileMap

@onready var button = $"../GroundButton/Button"

func _ready():
	set_layer_enabled(1,false)
	button.connect("enable_tilemap", showTilemap)
	button.connect("disable_tilemap", hideTilemap)

func showTilemap():
	set_layer_enabled(1,true)
	
func hideTilemap():
	set_layer_enabled(1,false)
