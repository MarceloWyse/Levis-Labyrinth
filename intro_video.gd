extends VideoStreamPlayer

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		stop()
		get_tree().change_scene_to_file("res://menu.tscn")
		

func _ready():
	play()
	await self.finished
	get_tree().change_scene_to_file("res://menu.tscn")
