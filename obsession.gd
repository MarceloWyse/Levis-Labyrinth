extends CharacterBody2D
@onready var finite_state_machine = $FiniteStateMachine
@onready var idle_state_2 = $FiniteStateMachine/IdleState2
@onready var chase = $FiniteStateMachine/Chase
@onready var levi = get_tree().get_first_node_in_group("Levi")
@onready var enemy_name = $"../UI/EnemyName"
@onready var stats = $Stats
@onready var damage_taken = $DamageTaken

var gravity = 900

func _ready():
	idle_state_2.connect("to_chase_state", finite_state_machine.change_state.bind(chase))
	chase.connect("to_idle_state", finite_state_machine.change_state.bind(idle_state_2))
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
#	move_and_collide(velocity * delta)

func _on_hurtbox_hurt(hitbox, damage):
	Sound.play(Sound.hit)
	enemy_name.get_node("TextureRect/Label").text = "Obsession"
	enemy_name.visible = true
	stats.health -= damage
	damage_taken.visible = true
	damage_taken.get_node("Label").text = str(damage)
	await get_tree().create_timer(1).timeout
	damage_taken.visible = false
	enemy_name.visible = false

func _on_stats_no_health():
	await get_tree().create_timer(0.3).timeout
	enemy_name.visible = false
	queue_free()
