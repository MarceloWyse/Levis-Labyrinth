extends State

@export var actor : Enemy
@export var animator : AnimatedSprite2D

signal to_attack_state

func _ready():
	set_physics_process(false)
	
func enter_state():
	set_physics_process(true)
	animator.play("walk")
	actor.velocity.x -= 25
	await get_tree().create_timer(1).timeout
	actor.velocity.x = 0
	actor.velocity.x += 25
	await get_tree().create_timer(1).timeout
	actor.velocity.x = 0
	to_attack_state.emit()
	
func exit_state():
	set_physics_process(false)

