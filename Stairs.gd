extends Area2D

@onready var levi = $"../Levi"
var climbing = false
#var climbing = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not levi : return
	elif overlaps_body(levi):
		if Input.is_action_pressed("ladder_up"):
			climbing = true
			levi.get_node("AnimatedSprite2D").play("climb")
			levi.gravity = 1
			levi.global_position += Vector2(0,-2)
		elif Input.is_action_just_released("ladder_up"):
			levi.get_node("AnimatedSprite2D").play("fall")
			levi.gravity = 900
	else:
		levi.gravity = 900
		climbing = false

	
