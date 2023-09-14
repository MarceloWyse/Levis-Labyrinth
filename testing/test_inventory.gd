extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
#	var inventory_array = get_tree().get_first_node_in_group("inventory")
	var inventory = get_tree().has_group("inventory")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
