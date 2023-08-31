extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	if position.y != 0:
#		position.y = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body is Player:
		body.money += 100
		queue_free()
