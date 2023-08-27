extends CharacterBody2D

@onready var levi = $"../../Levi"
@onready var enemy_name = $"../../UI/EnemyName"
@onready var damage_taken = $DamageTaken
@onready var stats = $Stats
@onready var hitbox = $Hitbox
@onready var collision_shape_2d = $Hitbox/CollisionShape2D
@onready var hurtbox = $Hurtbox
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var fire = $Fire
@onready var timer = $Timer

const ENEMY_BULLET_SCENE = preload("res://enemy_bullet.tscn")
var death = false
var death_vfx = preload("res://death_effect.tscn")
var bullet_speed = 30
var bullet_rotation = 45
var spread = 60

var speed = 10
var left_collided = false
var right_collided = false
var chasing = false
#@onready var walker = $".."
var pos = Vector2.ZERO
var pos_valid = false

func _ready():
	pass

func fire_bullet():
	var enemy_bullet = ENEMY_BULLET_SCENE.instantiate() as Projectile
	var world = get_tree().current_scene
	world.add_child.call_deferred(enemy_bullet)
	enemy_bullet.global_position = fire.global_position
	var direction = global_position.direction_to(fire.global_position)
	var velocity = direction.normalized() * bullet_speed
	velocity = velocity.rotated((randf_range(-deg_to_rad(spread), deg_to_rad(spread))))
	enemy_bullet.velocity = velocity
	
func _process(delta):

	if not chasing:
		$AnimationPlayer.play("blob2_move")
#		if pos_valid:
#			walker.global_position = pos
#			velocity.x = move_toward(global_position.x, walker.global_position.x, speed * delta)
#			pos = Vector2.ZERO
#			pos_valid = false

	if ray_cast_left.is_colliding():
#		animated_sprite_2d.scale.x = direction
#		velocity.x -= speed * delta
#		position.x -= 1
		animated_sprite_2d.flip_h = false
		left_collided = true
		chasing = true
#		timer.start()
		if timer.time_left == 0:
			timer.start()
			fire_bullet()
#		pos_valid = true
#		pos = global_position
		
	if not ray_cast_left.is_colliding() and left_collided:
#		move_toward(speed, 0, 20)
#		velocity.x = move_toward(velocity.x, 0, speed * delta)
		left_collided = false
		chasing = false
		
	if ray_cast_right.is_colliding():
#		velocity.x += speed * delta
#		position.x += 1
		animated_sprite_2d.flip_h = true
		right_collided = true
		chasing = true
		if timer.time_left == 0:
			timer.start()
			fire_bullet()
#		pos_valid = true
#		pos = global_position
		
	if not ray_cast_right.is_colliding() and right_collided:
#		velocity.x = 0
#		print(move_toward(velocity.x, 0, 20))
		right_collided = false
		chasing = false
				
#	move_and_slide()

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
