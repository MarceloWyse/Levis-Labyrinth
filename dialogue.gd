extends Panel

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var dialogue_1 = $"../../dialogue1"
@onready var dialogue_2 = $"../../dialogue2"

var playing = false
var dialogue1 = false
var dialogue2 = false
var cont = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	animated_sprite_2d.play("default")
	if Input.is_action_just_pressed("dialogue") and dialogue1:
		if cont == 0:
			get_node("RichTextLabel").text = "Primo, como você está? Aqui é o primo cachorro teste."
			cont += 1
		elif cont == 1:
			get_node("RichTextLabel").text = "Sim, essa caixa tem vários diálogos."
			cont += 1
		elif cont == 2:
			get_node("RichTextLabel").text = "Olha quantas falas eu possuo, todas diferentes! Depois eu fecho e não apareço novamente." 
			cont += 1
		elif cont == 3:
			get_node("RichTextLabel").text = "Também é impossível pausar o jogo durante nossa conversa!"
			cont += 1
		else:
			cont = 0
			hide()
			playing = false
			dialogue1 = false
			get_tree().paused = false
			dialogue_1.queue_free()
			
	elif Input.is_action_just_pressed("dialogue") and dialogue2:
		if cont == 0:
			get_node("RichTextLabel").text = "There are many puzzles and doors like that."
			cont += 1
		elif cont == 1:
			get_node("RichTextLabel").text = "To open them you'll need to press X on your keyboard or controller."
			cont += 1
		elif cont == 2:
			get_node("RichTextLabel").text = "It's the same button you've been pressing to read these lines. Pretty neat, huh." 
			cont += 1
		else:
			cont = 0
			hide()
			playing = false
			dialogue2 = false
			get_tree().paused = false
			dialogue_2.queue_free()
			
			
			
