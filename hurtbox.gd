class_name Hurtbox
extends Area2D

signal hurt(hitbox, damage)

var is_invincible = false:
	set(value):
		is_invincible = value
		disable_hurtbox.call_deferred(value)

func take_hit(hitbox, damage):
	if is_invincible : return
	hurt.emit(hitbox, damage)

func disable_hurtbox(value):
	for child in get_children():
		if child is CollisionPolygon2D or child is CollisionShape2D:
			child.disabled = value
