extends CharacterBody2D

@onready var walk_timer = $WalkTimer
@onready var stats = $Stats
@onready var damage_taken = $DamageTaken
@onready var enemy_name = $"../UI/EnemyName"
@onready var idle_timer = $IdleTimer

var idling = false
var walk_backwards = false
var walk_forward = false

@onready var animated_sprite_2d = $AnimatedSprite2D

func _process(_delta):
	
	move_and_slide()
	
#	var direction = global_position.direction_to(MainInstances.player.global_position)
	
	
	if idling:
		walk_backwards = false
		walk_forward = false
		velocity.x = 0
		animated_sprite_2d.play("idle")
		await animated_sprite_2d.animation_finished
		idling = false
		walk_backwards = true
	
	if walk_backwards:
#		walk_timer.start()
		$AnimatedSprite2D.play("walk")
		var my_tween = create_tween().tween_property(self, "velocity:x", velocity.x -10, 0.5)
		await my_tween.finished
#		walk_backwards = false
		walk_backwards = false
		walk_forward = true
		
	if walk_forward:
		velocity.x = 0
		var my_tween2 = create_tween().tween_property(self, "velocity:x", velocity.x + 10, 0.5)
		await my_tween2.finished
		walk_forward = false
#		idle_timer.start()
		idling = true

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

func _on_visible_on_screen_enabler_2d_screen_entered():
		animated_sprite_2d.play("wakeup")
		await animated_sprite_2d.animation_finished
		walk_backwards = false
		walk_forward = false
		idling = true
#		
func _on_visible_on_screen_enabler_2d_screen_exited():
	idling = false
	walk_backwards = false
	walk_forward = false
	animated_sprite_2d.play("hidden")
	await animated_sprite_2d.animation_finished
