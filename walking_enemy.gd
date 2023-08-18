extends CharacterBody2D

@onready var stats = $Stats

func _on_stats_no_health():
	queue_free()

func _on_hurtbox_hurt(hitbox, damage):
	stats.health -= damage
	print("oie")
