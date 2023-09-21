extends State

@export var actor : CharacterBody2D
@export var animation_player : AnimationPlayer
@export var ray_cast : RayCast2D

signal to_chase_state

func _ready():
	set_physics_process(false)

func enter_state():
	set_physics_process(true)
	animation_player.play("idle")

func exit_state():
	set_physics_process(false)

func _physics_process(delta):
	if ray_cast.is_colliding():
		to_chase_state.emit()
