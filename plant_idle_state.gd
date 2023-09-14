extends State

@export var actor : Enemy
@export var animator : AnimatedSprite2D
@onready var attack_hitbox = $"../../AttackHitbox"
@export var vision_cast : RayCast2D
var walk_cont = 0
var hide_cont = 0

signal to_walk_state
signal to_hide_state
func _ready():
	set_physics_process(false)
	
func enter_state():
	set_physics_process(true)
	attack_hitbox.monitoring = false
	animator.play("idle")
	
func exit_state():
	set_physics_process(false)
	
func _physics_process(_delta):
	if not vision_cast.is_colliding():
		hide_cont += 1
		walk_cont = 0
	if vision_cast.is_colliding():
		hide_cont = 0
		walk_cont += 1
	if walk_cont >= 100:
		to_walk_state.emit()
	if hide_cont >= 100:
		to_hide_state.emit()

