extends VideoStreamPlayer

func _ready():
	play()
	await self.finished
	get_tree().change_scene_to_file("res://menu.tscn")
