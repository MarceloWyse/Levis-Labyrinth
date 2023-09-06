extends Area2D

@onready var stairs = $"../Stairs"
@onready var levi = $"../Levi"
var climbing = false

func _process(_delta):
	if not levi : return
	elif overlaps_body(levi):
		stairs.set_process(false)
		if Input.is_action_pressed("ui_up"):
			climbing = true
			levi.get_node("AnimatedSprite2D").play("climb")
			levi.gravity = 1
			levi.global_position += Vector2(0,-2)
		elif Input.is_action_just_released("ui_up"):
			levi.get_node("AnimatedSprite2D").play("fall")
			levi.gravity = 900
	else:
		levi.gravity = 900
		stairs.set_process(true)
		climbing = false

	

