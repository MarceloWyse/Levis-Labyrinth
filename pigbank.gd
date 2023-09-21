extends AnimatedSprite2D

const MONEY_SCENE = preload("res://money_bag.tscn")
var money_counter = 0
var pig_broken = false

func _process(_delta):
	if not MainInstances.player : return
	if $Area2D.overlaps_body(MainInstances.player):
		if MainInstances.player.punching:
				if not pig_broken:
					Sound.play(Sound.pigbreak)
					pig_broken = true
				play("pig_break")				
				await animation_finished
				var world = get_tree().current_scene
				if money_counter == 0:
					var money = MONEY_SCENE.instantiate()
					money.global_position = global_position
					world.add_child(money)
					money_counter += 1
				queue_free()
