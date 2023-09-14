extends AnimatedSprite2D

@onready var label = $DashArea/Label
@onready var dialogue = $"../UI/Dialogue"
@onready var levi = $"../Levi"

# Called when the node enters the scene tree for the first time.
func _ready():
	label.visible = false

func _on_dash_area_body_entered(_body):
	dialogue.playing = true
	label.visible = true
	levi.dash_available = true
	get_tree().paused = true
	await get_tree().create_timer(1).timeout
	get_tree().paused = false
	label.visible = false
	dialogue.playing = false
	queue_free()
