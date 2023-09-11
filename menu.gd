extends Control

func _on_button_pressed():
	var my_tween = get_tree().create_tween()
	my_tween.tween_property(self, "modulate", Color(0,0,0,255), 1)
	await my_tween.finished
	get_tree().change_scene_to_file("res://world.tscn")

func _on_quit_btn_pressed():
	get_tree().quit()