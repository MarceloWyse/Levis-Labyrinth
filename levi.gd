class_name Player
extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var alfy_test = $AlfyTest
@onready var hitbox = $AlfyTest/Hitbox
@onready var ui = $"../UI"
@onready var animation_player = $AnimationPlayer
@onready var punch = $Hitbox/punch
@onready var hurtbox = $Hurtbox
@onready var sword = $Sword
@onready var label = $DamageCounter/Label
@onready var damage_counter = $DamageCounter
@onready var camera_2d = $Camera2D

var gravity = 900
var blue_key = false
var medal = false
var trophy = false
var initial_position

const SPEED = 100.0
const JUMP_VELOCITY = -340.0

func _ready():
	initial_position = global_position
	damage_counter.visible = false
	PlayerStats.connect("no_health", reparent_camera)
	PlayerStats.connect("no_health", queue_free)

func _physics_process(delta):

	if global_position.y > 500:
#		global_position = initial_position
		global_position = Vector2(-245,100)
		
	apply_gravity(delta)

	if Input.is_action_just_pressed("sword"):
		sword.get_node("AnimationPlayer").play("attack")

	if animated_sprite_2d.flip_h == false:
###		alfy_test.global_position = global_position + Vector2(-14,-28)
###		messing with the global_positon here breaks the collision of the hitbox
		alfy_test.flip_h = false
##
		if Input.is_action_just_pressed("alfy"):
##			alfy_test.global_position = global_position + Vector2(-14,-28)
			animation_player.play("alfy_test_right")
#
	if animated_sprite_2d.flip_h == true:
		alfy_test.flip_h = true
		if Input.is_action_just_pressed("alfy"):
			animation_player.play("alfy_test_left")
#
	if Input.is_action_just_pressed("attack"):
		if animated_sprite_2d.flip_h == false:
			animation_player.play("attack_right")
		else:
			animation_player.play("attack_left")	

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x > 0:
			punch.global_position = global_position + Vector2(+7, -20)
			alfy_test.global_position = global_position + Vector2(-14,-28)
			animated_sprite_2d.flip_h = false

		if velocity.x > 0 and velocity.y == 0:
			animated_sprite_2d.play("walk")

		elif velocity.x < 0 and velocity.y == 0:
			animated_sprite_2d.play("walk")
			animated_sprite_2d.flip_h = true
			punch.global_position = global_position + Vector2(-7,-20)
			alfy_test.global_position = global_position + Vector2(14,-28)
#
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		Sound.play(Sound.jump)
#		animated_sprite_2d.play("jump_full")
		if velocity.y > 0:
#			animated_sprite_2d.play("jump_full")
			animated_sprite_2d.play("jump")

		if velocity.y < 0:
			animated_sprite_2d.play("fall")
#		await get_tree().create_timer(0.4).timeout
#		if Input.is_action_pressed("dash"):
#			print("oie")
#			global_position += Vector2(20,0)

	elif not direction and velocity.y == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite_2d.play("idle")
	
	var was_on_floor = is_on_floor()
	
	move_and_slide()

	if was_on_floor and not is_on_floor():
		animated_sprite_2d.play("fall")

	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * 8)
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
func _on_hurtbox_hurt(_hitbox, damage):
	damage_counter.visible = true
	PlayerStats.health -= damage
	Sound.play(Sound.hit)
	var my_tween = get_tree().create_tween()
	label.text = str(damage)
	label.position = Vector2(0,0)
	hurtbox.is_invincible = true
#	await my_tween.finished
	animation_player.play("blink")
	my_tween.tween_property(label, "position", Vector2(-3, -1), 0.5)
	await animation_player.animation_finished
	damage_counter.visible = false
	hurtbox.is_invincible = false
#	Sound.play(Sound.hurt)
##	Events.screen_shake.emit(3, 0.2)

func reparent_camera():
	camera_2d.reparent(get_tree().current_scene)
