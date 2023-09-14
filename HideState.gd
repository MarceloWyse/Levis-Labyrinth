extends State

@export var animator : AnimatedSprite2D
@export var vision_cast : RayCast2D

signal to_idle_state
# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	
func enter_state():	
	set_physics_process(true)
	animator.play("hidden")
	
func exit_state():
	set_physics_process(false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if vision_cast.is_colliding():
		animator.play("wakeup")
		await animator.animation_finished
		to_idle_state.emit()
