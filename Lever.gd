extends Area2D

@onready var door_up = $"../DoorUp"
@onready var lever = $lever
@onready var lever_collision = $lever_collision
@onready var doorup_collision = $"../DoorUp/doorup_collision"
@onready var levi = $"../Levi"
@onready var x_button = $X_button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	if not levi : return
	if overlaps_body(levi):
		if Input.is_action_just_pressed("dialogue"):
			lever.play("lever")
			await get_tree().create_timer(0.5).timeout
			lever_collision.queue_free()
			door_up.get_node("slider_door_up").play("move_door")
			doorup_collision.queue_free()

func _on_body_entered(_body):
	x_button.visible = true

func _on_body_exited(_body):
	x_button.visible = false
