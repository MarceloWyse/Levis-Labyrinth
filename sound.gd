extends Node

#var sounds_path = "res://music_and_sounds"

@export var hit : AudioStream
@export var jump : AudioStream

@onready var sound_players = get_children()

func play(sound_stream, pitch_scale = 1.0, volume_db = 0.0):
	for audio in sound_players:
		if not audio.playing:
			audio.volume_db = volume_db
			audio.stream = sound_stream
			audio.pitch_scale = pitch_scale
			audio.play()
			return
