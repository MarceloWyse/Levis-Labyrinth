extends Node

@export var main_theme : AudioStream
@export var menu_theme : AudioStream
@export var second_act : AudioStream
@onready var audio_stream_player = $AudioStreamPlayer

func play(song, from_position):
	audio_stream_player.stream = song
	audio_stream_player.play(from_position)

func fade_music(duration = 1.0):
	var previous_volume = audio_stream_player.volume_db
	var volume_fade = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	volume_fade.tween_property(audio_stream_player, "volume_db", -50.0, duration)
	await volume_fade.finished
	audio_stream_player.stop()
	audio_stream_player.volume_db = previous_volume
