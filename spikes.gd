extends AnimatedSprite2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

func _on_timer_timeout():
	audio_stream_player_2d.play()
