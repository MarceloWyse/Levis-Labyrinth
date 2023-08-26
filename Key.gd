extends Area2D

func _on_body_entered(body):
	if body.ui.add_item_to_inventory($Sprite2D.texture):
		queue_free()
