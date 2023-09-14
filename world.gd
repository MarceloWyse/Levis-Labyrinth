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
@onready var jump_pop_up = $Dialogues/JumpPopUp
@onready var fight_pop_up = $Dialogues/FightPopUp
@onready var break_pop_up = $Dialogues/BreakPopUp
@onready var too_far_pop_up = $Dialogues/TooFarPopUp
@onready var dash_camera = $DashCamera
@onready var ladder_pop_up = $Dialogues/LadderPopUp
@onready var lever_pop_up = $Dialogues/LeverPopUp
@onready var animated_sprite_2d = $ExitDoor/AnimatedSprite2D
@onready var look_for_the_exit = $Dialogues/LookForTheExit
@onready var how_to_dash = $Dialogues/HowToDash

var opened = false
var lever_dialogue_counter = 0
var reset_health = PlayerStats.max_health

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
#	var bold = popup_alfy_label.label_settings.font_color
	popup_alfy_label.text = "Alfy: use WASD or the arrow keys to move."
	pop_up_timer.start()
	PlayerStats.connect("no_health", restart_scene)
	#$YourLabel.set("theme_override_colors/font_color", Color(1, 0, 0))


func _on_cd_body_entered(_body):
	levi.cd = true

func _on_dstation_body_entered(_body):
	levi.dstation = true

func _on_d_controller_body_entered(_body):
	levi.dcontroller = true

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
	await get_tree().create_timer(2).timeout
	levi_dialogue("It seems too far away to jump...")
	await get_tree().create_timer(3).timeout
	pop_up_levi.visible = false
	alfy_dialogue("Levi, perhaps you should search upstairs?")
	levi.get_node("Camera2D").enabled = false
	get_tree().paused = true
	await get_tree().create_timer(1.5).timeout
	get_tree().paused = false
	dash_camera.enabled = false
	levi.get_node("Camera2D").enabled = true
	dash_camera.enabled = true
	pop_up_timer.start()
	too_far_pop_up.queue_free()

func levi_dialogue(my_text : String):
	pop_up_levi.visible = true
	popup_levi_label.text = "Levi: " + my_text

func alfy_dialogue(my_text : String):
	pop_up_alfy.visible = true
	popup_alfy_label.text = "Alfy: " + my_text

func _on_ladder_pop_up_body_entered(_body):
	alfy_dialogue("Press W or the UP arrow key to climb stairs.")
	pop_up_timer.start()
	ladder_pop_up.queue_free()

func _on_lever_pop_up_body_entered(_body):
	lever_pop_up.set_deferred("monitoring", false)
	alfy_dialogue("Press X to interact with objects.")
	await get_tree().create_timer(3.0).timeout
	pop_up_alfy.visible = false
	levi_dialogue("Ok, thanks")
	await get_tree().create_timer(2.0).timeout
	pop_up_levi.visible = false
	lever_dialogue_counter += 1
	lever_pop_up.queue_free()

func _on_exit_door_body_entered(body):
	if levi.dstation and levi.dcontroller and levi.cd and not(opened):
		body.velocity.x = 0
		body.animated_sprite_2d.play("idle")
		body.during_animation = true
		animated_sprite_2d.play("exit_door_open") 
		await get_tree().create_timer(1.2).timeout
		opened = true
		get_tree().change_scene_to_file("res://level_two.tscn")

func restart_scene():
	await get_tree().create_timer(2).timeout
#	Music.fade_music(0.2)
	PlayerStats.max_health = reset_health
	PlayerStats.set_health(reset_health)
	get_tree().change_scene_to_file("res://menu.tscn")
	
func _on_look_for_the_exit_body_entered(body):
	if body.dcontroller and body.cd:
		look_for_the_exit.set_deferred("monitoring", false)
		await get_tree().create_timer(0.5).timeout
		alfy_dialogue("We should look for the EXIT now.")
		pop_up_timer.start()
		look_for_the_exit.queue_free()
	else:
		look_for_the_exit.set_deferred("monitoring", false)
		await get_tree().create_timer(0.5).timeout
		alfy_dialogue("We don't have all the items we need yet")
		await get_tree().create_timer(4).timeout
		pop_up_timer.start()
		look_for_the_exit.queue_free()
	
func _on_how_to_dash_body_entered(body):
	if body.dash_available:
		how_to_dash.set_deferred("monitoring", false)
		alfy_dialogue("Levi! Try out your AIR DASH")
		await get_tree().create_timer(2).timeout
		alfy_dialogue("Air Dash = JUMP + SHIFT")
		await get_tree().create_timer(2).timeout
		pop_up_timer.start()
		how_to_dash.queue_free()
	
