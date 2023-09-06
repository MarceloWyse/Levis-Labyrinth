extends Area2D

@onready var tile_map = $"../../TileMap"
@onready var button_press = $ButtonPress
@onready var levi = $"../../Levi"
@onready var ball = $"../../Ball"
signal disable_tilemap
signal enable_tilemap

var pressed = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_body_entered(body):
#	if not body is Player or not body is Ball: return
#	if not body is Ball : return
	if body is Ball or body is Player:
		if not pressed:
			button_press.play("press")
			emit_signal("disable_tilemap")
		if body is Ball:
			emit_signal("disable_tilemap")
			pressed = true
			await get_tree().create_timer(0.2).timeout
			ball.set_deferred("freeze", true)
#			set_deferred("monitorable", false)
			
func _on_body_exited(body):
	if body is Ball or body is Player:
		if not pressed:
			button_press.play("unpressed")
			emit_signal("enable_tilemap")
