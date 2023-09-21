extends State

@export var actor : Enemy
@export var animator : AnimatedSprite2D
@onready var attack_hitbox = $"../../AttackHitbox"
@export var vision_cast : RayCast2D
@onready var lost_sight_timer = $"../../LostSightTimer"

signal to_walk_state
signal to_hide_state
func _ready():
	set_physics_process(false)
	
func enter_state():
	set_physics_process(true)
	lost_sight_timer.wait_time = 5
	attack_hitbox.monitoring = false
	animator.play("idle")
	await animator.animation_finished
	lost_sight_timer.start()
	
func exit_state():
	lost_sight_timer.stop()
	set_physics_process(false)
	
func _physics_process(_delta):
	if vision_cast.is_colliding():
		to_walk_state.emit()

func _on_lost_sight_timer_timeout():
		to_hide_state.emit()
