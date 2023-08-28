extends Node2D

@onready var label = $Label
@onready var dialogue = $"../UI/Dialogue"

func _ready():
	label.visible = false

func _on_area_2d_body_entered(body):
	dialogue.playing = true
	label.visible = true
	PlayerStats.max_health += 5
	PlayerStats.health = PlayerStats.max_health
	get_tree().paused = true
	await get_tree().create_timer(1).timeout
	get_tree().paused = false
	label.visible = false
	dialogue.playing = false
	queue_free()
