class_name Player
extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ui = $"../UI"
@onready var animation_player = $AnimationPlayer
@onready var punch = $PunchHitbox/punch
@onready var hurtbox = $Hurtbox
@onready var label = $DamageCounter/Label
@onready var damage_counter = $DamageCounter
@onready var camera_2d = $Camera2D
@onready var progress_bar = $"../UI/ProgressBarLabel/ProgressBar"
@onready var money_label = $"../UI/Coin/MoneyLabel"
@onready var dash_timer = $DashTimer
@onready var alfy = $Alfy
@onready var hitbox = $Alfy/Hitbox
@onready var stairs = $"../Stairs"

@export var GHOST_SCENE : PackedScene
var money : int = 0
var gravity = 900
var blue_key = false
var medal = false
var trophy = false
var initial_position
var punching = false
var dashing = false
var knockback = false
const SPEED = 100.0
const JUMP_VELOCITY = -340.0

func _ready():
	MainInstances.player = self
	initial_position = global_position
	damage_counter.visible = false
	PlayerStats.connect("no_health", reparent_camera)
	PlayerStats.connect("no_health", queue_free)

func _physics_process(delta):
	
	money_label.text = str(money)
	
	progress_bar.value = $AlfyTimer.time_left

	if global_position.y > 500:
#		global_position = initial_position
		global_position = Vector2(-245,100)
		
	apply_gravity(delta)
	
	if animated_sprite_2d.flip_h == false:
###		alfy.global_position = global_position + Vector2(-14,-28)
###		DON'T use the line above! messing with the global_positon here breaks the collision of the hitbox
		alfy.flip_h = false
##
		if Input.is_action_just_pressed("alfy") and $AlfyTimer.time_left == 0:
			animation_player.play("alfy_test_right")
			$AlfyTimer.start()
#
	if animated_sprite_2d.flip_h == true:
		alfy.flip_h = true
		if Input.is_action_just_pressed("alfy") and $AlfyTimer.time_left == 0:
			animation_player.play("alfy_test_left")
			$AlfyTimer.start()
#
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and not punching and not knockback:
		velocity.x = direction * SPEED
		if velocity.x > 0:
			alfy.global_position = global_position + Vector2(-14,-28)
			animated_sprite_2d.flip_h = false

		if velocity.x > 0 and velocity.y == 0:
			animated_sprite_2d.play("walk")

		elif velocity.x < 0 and velocity.y == 0:
			animated_sprite_2d.play("walk")
			animated_sprite_2d.flip_h = true
			alfy.global_position = global_position + Vector2(14,-28)
#
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not knockback:
		velocity.y = JUMP_VELOCITY
		Sound.play(Sound.jump)
		if velocity.y > 0:
			animated_sprite_2d.play("jump")

		if velocity.y < 0 and not dashing:
			animated_sprite_2d.play("fall")

	if not is_on_floor():
		if Input.is_action_just_pressed("dash") and dash_timer.time_left == 0 and not stairs.climbing:
			dashing = true
			gravity = 0
			
			animated_sprite_2d.play("dash")
			$GhostTimer.start()
			if animated_sprite_2d.flip_h == false:
				var my_tween = get_tree().create_tween()
				my_tween.tween_property(self, "velocity:x", 250, 0.2)
#				
			else:
				var my_tween = get_tree().create_tween()
				my_tween.tween_property(self, "velocity:x", velocity.x - 250, 0.2)
#				
			dash_timer.start()
			await get_tree().create_timer(0.7).timeout
			$GhostTimer.stop()
			gravity = 900 
			dashing = false
			
	if not direction and velocity.y == 0 and not punching and not knockback:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite_2d.play("idle")
	
	if Input.is_action_just_pressed("attack"):
		punching = true
		if animated_sprite_2d.flip_h == false:
			velocity.x = 0
			animated_sprite_2d.play("punch")
			animation_player.play("attack_right")
			await animated_sprite_2d.animation_finished
			punching = false
		else:
			velocity.x = 0
			animated_sprite_2d.play("punch")
			animation_player.play("attack_left")
			await animation_player.animation_finished
			punching = false
			
	var was_on_floor = is_on_floor()
	
	move_and_slide()

	if was_on_floor and not is_on_floor() and not knockback and not dashing:
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
	knockback = true
	velocity = Vector2.ZERO
	PlayerStats.health -= damage
	hurtbox.is_invincible = true
	$InvincibilityTimer.start()
	Sound.play(Sound.hit)
	label.text = str(damage)
	label.position = Vector2(0,0)
	animated_sprite_2d.play("knockback")
	
	if $AnimatedSprite2D.flip_h == false:
		velocity.x = velocity.x - 30
		velocity.y = velocity.y - 100
	if $AnimatedSprite2D.flip_h == true:
		velocity.x = velocity.x + 30
		velocity.y = velocity.y - 100

	await get_tree().create_timer(0.5).timeout
	damage_counter.visible = false
	knockback = false
##	Events.screen_shake.emit(3, 0.2)

func reparent_camera():
	camera_2d.reparent(get_tree().current_scene)

func ghost_spawn():
	var world = get_tree().current_scene
	var ghost = GHOST_SCENE.instantiate()
	ghost.set_property(position, $AnimatedSprite2D.flip_h, $AnimatedSprite2D.frame)
	
	if ghost.flip_h == false:
		ghost.position = position + Vector2(-10,-5)
	else:
		ghost.position = position + Vector2(10,-5)
	
	world.add_child(ghost)
	
func _on_ghost_timer_timeout():
	ghost_spawn()

func _on_invincibility_timer_timeout():
	hurtbox.is_invincible = false
