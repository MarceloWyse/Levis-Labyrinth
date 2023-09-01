extends Node2D

@onready var stats = $Stats
@onready var damage_taken = $DamageTaken
@onready var enemy_name = $"../UI/EnemyName"

func _on_stats_no_health():
	await get_tree().create_timer(1).timeout
	enemy_name.visible = false
	queue_free()

func _on_hurtbox_hurt(_hitbox, damage):
	stats.health -= damage
	Sound.play(Sound.hit)
	enemy_name.get_node("TextureRect/Label").text = "Sadness"
	enemy_name.visible = true
	stats.health -= damage
	damage_taken.visible = true
	damage_taken.get_node("Label").text = str(damage)
	await get_tree().create_timer(1).timeout
	damage_taken.visible = false
	enemy_name.visible = false
