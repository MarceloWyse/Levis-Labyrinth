extends AnimatedSprite2D

func _on_area_2d_body_entered(body):
	if not body is Player: return
	play("bubbles")
