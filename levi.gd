class_name Player
extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var alfy_test = $AlfyTest
@onready var hitbox = $AlfyTest/Hitbox
@onready var ui = $"../UI"
@onready var animation_player = $AnimationPlayer
@onready var punch = $Hitbox/punch
@onready var hurtbox = $Hurtbox

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var blue_key = false
var medal = false
var trophy = false

const SPEED = 100.0
const JUMP_VELOCITY = -320.0

func _physics_process(delta):

	apply_gravity(delta)

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
#		animated_sprite_2d.play("jump_full")
		if velocity.y > 0:
			animated_sprite_2d.play("jump_full")
#			animated_sprite_2d.play("jump")
		if velocity.y < 0:
			animated_sprite_2d.play("fall")
#		await get_tree().create_timer(0.4).timeout
#		if Input.is_action_pressed("dash"):
#			print("oie")
#			global_position += Vector2(20,0)

	elif not direction and velocity.y == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite_2d.play("idle")
	
	move_and_slide()

	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * 10)
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
func _on_hurtbox_hurt(hitbox, damage):
	PlayerStats.health -= damage
	hurtbox.is_invincible = true
	animation_player.play("blink")
	await animation_player.animation_finished
	hurtbox.is_invincible = false
#	Sound.play(Sound.hurt)
##	Events.screen_shake.emit(3, 0.2)
