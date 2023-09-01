extends Control

@onready var button = $Button

func _ready():
	$Button.hide()
	var my_tween3 = get_tree().create_tween()
#	my_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	my_tween3.tween_property($Label, "modulate", Color(0.14901961386204, 0.43921568989754, 0.55686277151108), 1.0)
	await my_tween3.finished	
	var my_tween24 = get_tree().create_tween()
	my_tween24.tween_property($Label, "modulate", Color(0.15686275064945, 0.73333334922791, 0.92941176891327), 0.5)
	await my_tween24.finished

func _on_timer_timeout():
	var my_tween = get_tree().create_tween()
#	my_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	my_tween.tween_property($Label, "modulate", Color(0.14901961386204, 0.43921568989754, 0.55686277151108), 1.0)
	await my_tween.finished	
	var my_tween2 = get_tree().create_tween()
	my_tween2.tween_property($Label, "modulate", Color(0.15686275064945, 0.73333334922791, 0.92941176891327), 0.5)
	await my_tween2.finished

func _on_button_pressed():
	get_tree().quit()

func _on_button_timer_timeout():
	$Button.show()
	var my_tween = get_tree().create_tween()
	my_tween.tween_property($Button, "self_modulate", Color(0.14901961386204, 0.43921568989754, 0.55686277151108), 1.0)
	await my_tween.finished
	button.grab_focus()
