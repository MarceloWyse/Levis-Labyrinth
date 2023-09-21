extends AnimatedSprite2D
@onready var levi = $"../../Levi"

func _on_area_2d_body_entered(body):
	if not body is Player: return
	Sound.play(Sound.water_bottle)
	play("bubbles")
