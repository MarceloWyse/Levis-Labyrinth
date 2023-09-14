extends CharacterBody2D
class_name Enemy

@onready var stats = $Stats
@onready var damage_taken = $DamageTaken
@onready var enemy_name = $"../UI/EnemyName"
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var finite_state_machine = $FiniteStateMachine
@onready var idle_state = $FiniteStateMachine/IdleState
@onready var walk_state = $FiniteStateMachine/WalkState
@onready var attack_state = $FiniteStateMachine/AttackState
@onready var hide_state = $FiniteStateMachine/HideState

var seconds : int

func _ready():
	idle_state.connect("to_walk_state", finite_state_machine.change_state.bind(walk_state))
	walk_state.connect("to_attack_state", finite_state_machine.change_state.bind(attack_state))
	attack_state.connect("to_idle_state", finite_state_machine.change_state.bind(idle_state))
	idle_state.connect("to_hide_state", finite_state_machine.change_state.bind(hide_state))
	hide_state.connect("to_idle_state", finite_state_machine.change_state.bind(idle_state))
	
func _physics_process(_delta):
	move_and_slide()

func _on_stats_no_health():
	await get_tree().create_timer(1).timeout
	enemy_name.visible = false
	queue_free()

func _on_hurtbox_hurt(_hitbox, damage):
	stats.health -= damage
	Sound.play(Sound.hit)
	enemy_name.get_node("TextureRect/Label").text = "Sadness"
	enemy_name.visible = true
	stats.health -= damage
	damage_taken.visible = true
	damage_taken.get_node("Label").text = str(damage)
	await get_tree().create_timer(1).timeout
	damage_taken.visible = false
	enemy_name.visible = false
