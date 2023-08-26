extends CharacterBody2D
@onready var damage_taken = $DamageTaken
@onready var stats = $Stats
@onready var hitbox = $Hitbox
@onready var collision_shape_2d = $Hitbox/CollisionShape2D
@onready var hurtbox = $Hurtbox
@onready var enemy_name = $"../UI/EnemyName"
@onready var levi = $"../Levi"
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var animated_sprite_2d = $AnimatedSprite2D

var death = false
var death_vfx = preload("res://death_effect.tscn")

var speed = 10
#var direction = 1
var left_collided = false
var right_collided = false

func _process(delta):
	if ray_cast_left.is_colliding():
#		animated_sprite_2d.scale.x = direction
		velocity.x -= speed * delta
		animated_sprite_2d.flip_h = false
		left_collided = true
		
	if not ray_cast_left.is_colliding() and left_collided:
#		move_toward(speed, 0, 20)
		velocity.x = 0
		left_collided = false
		
	if ray_cast_right.is_colliding():
		velocity.x += speed * delta
		animated_sprite_2d.flip_h = true
		right_collided = true
	if not ray_cast_right.is_colliding() and right_collided:
		velocity.x = 0
#		print(move_toward(velocity.x, 0, 20))
		right_collided = false
		
		
	move_and_slide()

func _on_stats_no_health():
	if death : return
#	hitbox.queue_free()
	hitbox.queue_free()	
	hurtbox.queue_free()
	var my_tween = create_tween()
	my_tween.tween_property(self, "global_position", global_position - Vector2(6,0), 0.3)
	my_tween.tween_property(self, "global_position", global_position - Vector2(-6,0), 0.3)
	await my_tween.finished
#	await get_tree().create_timer(1).timeout
	queue_free()
	enemy_name.visible = false
	death = true

func _on_hurtbox_hurt(_hitbox, damage):
	Sound.play(Sound.hit)
	enemy_name.visible = true
	stats.health -= damage
	damage_taken.visible = true
	damage_taken.get_node("Label").text = str(damage)
	await get_tree().create_timer(1).timeout
	damage_taken.visible = false
	enemy_name.visible = false
