extends CanvasLayer
@onready var ui = $"."

func add_item_to_inventory(sprite):
	#first I have to check if the slots are empty or not
	for i in $Inventory/GridContainer.get_children(): #iterates through each slot
		if i.get_node("icon").texture == null: #if a slot doesn't have a texture it will be null
			i.get_node("icon").texture = sprite #so it can receive the texture of the sprite I want
			return true
	return false #if all are full it does nothing 

