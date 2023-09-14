extends Sprite2D
@onready var frame_timer = $"../frameTimer"
var cont = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	frame_timer.start()

func _on_frame_timer_timeout():
	if frame == 3:
		frame = 0
	else: 
		frame += 1
	
