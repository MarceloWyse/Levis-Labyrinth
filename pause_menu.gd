extends ColorRect

@onready var dialogue = $"../Dialogue"
var pause = false: 
	set(value):
		pause = value
		get_tree().paused = value
		visible = value

func _process(_delta):
	if Input.is_action_just_pressed("pause_button") and not dialogue.playing:
		pause = !pause
