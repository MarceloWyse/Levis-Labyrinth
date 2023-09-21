extends State

@export var actor : CharacterBody2D
@export var animation_player : AnimationPlayer
@export var ray_cast : RayCast2D
@onready var levi = get_tree().get_first_node_in_group("Levi")
var cont

signal to_idle_state

func _ready():
	set_physics_process(false)

func enter_state():
	set_physics_process(true)
	animation_player.play("run")
	cont = 0
	
func exit_state():
	set_physics_process(false)
	actor.velocity.x = 0
	cont = 0
	
func _physics_process(delta):
	if levi != null:
		var direction = actor.global_position.direction_to(levi.global_position)
		if direction.x > 0:
			actor.get_node("Sprite2D").flip_h = true
			actor.velocity.x = 40
			ray_cast.rotation = deg_to_rad(180)

		elif direction.x < 0:
			actor.get_node("Sprite2D").flip_h = false
			actor.scale.x = 1
			ray_cast.rotation = deg_to_rad(360)
			actor.velocity.x = -40
	
	if ray_cast.is_colliding():
		cont = 0
	if not ray_cast.is_colliding():
		cont += 1
		if cont == 250:
			to_idle_state.emit()
