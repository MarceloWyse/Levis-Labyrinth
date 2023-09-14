extends State

#@export var actor : Enemy
@export var animator : AnimatedSprite2D

signal go_to_move_state

func _ready():
	set_physics_process(false)

func enter_state():
	set_physics_process(true)
	animator.play("idle")	

func exit_state():
	set_physics_process(false)

func _physics_process(delta):
	pass
