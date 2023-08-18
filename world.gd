extends Node2D

@onready var dialogue = $UI/Dialogue
@onready var levi = $Levi
@onready var door = $Door
#@onready var key = $Key
@onready var animation_player = $AnimationPlayer
var opened = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_key_body_entered(body):
	levi.blue_key = true
#	key.queue_free()

func _on_door_body_entered(body):
	if levi.blue_key and levi.medal and levi.trophy and not(opened):
		animation_player.play("new_animation")
		await get_tree().create_timer(1.2).timeout
		opened = true
		get_tree().change_scene_to_file("res://level_two.tscn")
#		await get_tree().create_timer(1.0).timeout
#		animation_player.queue_free()
		
func _on_medal_body_entered(body):
	levi.medal = true

func _on_trophy_body_entered(body):
	levi.trophy = true

func _on_area_2d_body_entered(body):
	dialogue.visible = true
	dialogue.playing = true
	dialogue.dialogue1 = true
	dialogue.get_node("RichTextLabel").text = "Woof-Woof!"
	get_tree().paused = true

func _on_dialogue_2_body_entered(body):
	dialogue.visible = true
	dialogue.playing = true
	dialogue.dialogue2 = true
	dialogue.get_node("RichTextLabel").text = "Do you see the lever ahead?"
	get_tree().paused = true
