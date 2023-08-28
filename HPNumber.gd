extends Label

func _ready():
	pass
#	PlayerStats.max_health_changed.connect(change_health)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = str(PlayerStats.health)

#func change_health():
#	text = str(PlayerStats.health)
