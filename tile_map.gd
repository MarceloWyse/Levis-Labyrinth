extends TileMap

@onready var button = $"../GroundButton/Button"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_layer_enabled(1,false)
	button.connect("enable_tilemap", showTilemap)
	button.connect("disable_tilemap", hideTilemap)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func showTilemap():
	set_layer_enabled(1,true)
	
func hideTilemap():
	set_layer_enabled(1,false)
