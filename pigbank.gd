extends AnimatedSprite2D

func _process(delta):
	if not MainInstances.player : return
	if $Area2D.overlaps_body(MainInstances.player):
		if MainInstances.player.punching:
				play("pig_break")
				await animation_finished
				queue_free()
