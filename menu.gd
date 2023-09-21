extends Control
@onready var texture_rect_2 = $TextureRect2

func _ready():
	var my_tween = create_tween()
	my_tween.tween_property(texture_rect_2, "modulate", Color(1, 1, 1, 0), 1.5)
	await my_tween.finished
	Music.play(Music.menu_theme, 0)

func _on_button_pressed():
	Music.fade_music(1)
	var my_tween = get_tree().create_tween()
	my_tween.tween_property(self, "modulate", Color(0,0,0,255), 1)
	await my_tween.finished
	get_tree().change_scene_to_file("res://world.tscn")

func _on_quit_btn_pressed():
	get_tree().quit()
