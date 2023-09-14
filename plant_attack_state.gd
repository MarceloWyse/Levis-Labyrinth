extends State

@export var actor : Enemy
@export var animator : AnimatedSprite2D
@onready var attack_hitbox = $"../../AttackHitbox"

signal to_idle_state

func _ready():
	set_physics_process(false)
	
func enter_state():
	set_physics_process(true)
	animator.play("attack")
	attack_hitbox.monitoring = true
	actor.velocity.y -= 35
	await get_tree().create_timer(0.5).timeout
	actor.velocity.y = 0
	actor.velocity.y += 50
	await get_tree().create_timer(0.5).timeout
	actor.velocity.y = 0
	to_idle_state.emit()
	
func exit_state():
	set_physics_process(false)
	
