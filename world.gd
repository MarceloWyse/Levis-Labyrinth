extends Node2D

@onready var color_rect = $FadeOut/ColorRect
@onready var dialogue = $UI/Dialogue
@onready var levi = $Levi
@onready var door = $ExitDoor
@onready var pop_up_alfy = $PopUpAlfy
@onready var popup_alfy_label = $PopUpAlfy/ColorRect/Label
@onready var pop_up_timer = $PopUpAlfy/PopUpTimer
@onready var pop_up_levi = $PopUpLevi
@onready var popup_levi_label = $PopUpLevi/ColorRect/Label
@onready var pop_up_timer_2 = $PopUpLevi/PopUpTimer2
@onready var jump_pop_up = $JumpPopUp
@onready var fight_pop_up = $FightPopUp
@onready var break_pop_up = $BreakPopUp
@onready var too_far_pop_up = $TooFarPopUp
@onready var reenable_pop_up = $TooFarPopUp/Reenable_PopUp
@onready var dash_camera = $DashCamera
@onready var ladder_pop_up = $LadderPopUp
@onready var lever_pop_up = $LeverPopUp
@onready var animated_sprite_2d = $ExitDoor/AnimatedSprite2D

var opened = false
var lever_dialogue_counter = 0

func _ready():
	$FadeOut.visible = true
	pop_up_alfy.visible = false
	pop_up_levi.visible = false
	var my_tween = get_tree().create_tween()
	my_tween.tween_property(color_rect, "color", Color(0, 0, 0, 0), 1)
	await my_tween.finished
	$FadeOut.visible = false
	Music.play(Music.main_theme, 0)
	await get_tree().create_timer(0.5).timeout
	pop_up_alfy.visible = true
	popup_alfy_label.text = "Alfy: Use WASD or the arrow keys to move."
	pop_up_timer.start()
	
func _on_key_body_entered(_body):
	levi.blue_key = true
#	key.queue_free()

func _on_medal_body_entered(_body):
	levi.medal = true

func _on_trophy_body_entered(_body):
	levi.trophy = true

func _on_pop_up_timer_timeout():
	pop_up_alfy.visible = false

func _on_jump_pop_up_body_entered(_body):
	pop_up_alfy.visible = true
	popup_alfy_label.text = "Alfy: Press the SPACEBAR to jump!"
	pop_up_timer.start()
	jump_pop_up.queue_free()

func _on_fight_pop_up_body_entered(_body):
	pop_up_alfy.visible = true
	popup_alfy_label.text = "Alfy: Press F to punch or G for my attack!"
	pop_up_timer.start()
	fight_pop_up.queue_free()

func _on_break_pop_up_body_entered(_body):
	pop_up_levi.visible = true
	popup_levi_label.text = "Levi: I could break this pigbank with an attack..."
	pop_up_timer_2.start()
	break_pop_up.queue_free()

func _on_pop_up_timer_2_timeout():
	pop_up_levi.visible = false

func _on_too_far_pop_up_body_entered(_body):
	too_far_pop_up.set_deferred("monitoring", false)
	levi_dialogue("It seems too far away to jump...")
	await get_tree().create_timer(2).timeout
	pop_up_levi.visible = false
	alfy_dialogue("Levi, perhaps you should search upstairs?")
	levi.get_node("Camera2D").enabled = false
	get_tree().paused = true
	await get_tree().create_timer(2).timeout
	get_tree().paused = false
	dash_camera.enabled = false
	levi.get_node("Camera2D").enabled = true
	dash_camera.enabled = true
	pop_up_timer.start()
	reenable_pop_up.start()

func levi_dialogue(my_text : String):
	pop_up_levi.visible = true
	popup_levi_label.text = "Levi: " + my_text

func alfy_dialogue(my_text : String):
	pop_up_alfy.visible = true
	popup_alfy_label.text = "Alfy: " + my_text

func _on_reenable_pop_up_timeout():
	too_far_pop_up.set_deferred("monitoring" ,true)

func _on_ladder_pop_up_body_entered(_body):
	alfy_dialogue("Press W or the UP arrow key to climb stairs.")
	pop_up_timer.start()
	ladder_pop_up.queue_free()

func _on_lever_pop_up_body_entered(_body):
	lever_pop_up.set_deferred("monitoring", false)
	alfy_dialogue("Press X to interact with objects, like this lever here.")
	await get_tree().create_timer(3.0).timeout
	pop_up_alfy.visible = false
	levi_dialogue("Ok, thanks")
	await get_tree().create_timer(2.0).timeout
	pop_up_levi.visible = false
	lever_dialogue_counter += 1
	lever_pop_up.queue_free()

func _on_exit_door_body_entered(_body):
	if levi.blue_key and levi.medal and levi.trophy and not(opened):
		animated_sprite_2d.play("exit_door_open") 
		await get_tree().create_timer(1.2).timeout
		opened = true
		get_tree().change_scene_to_file("res://level_two.tscn")
