extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	ghosting()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_property(pos, tx_flip_h, tx_frame):
	position = pos
	flip_h = tx_flip_h
	frame = tx_frame
	
func ghosting():
	var my_tween = get_tree().create_tween()
	my_tween.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 0.45)
