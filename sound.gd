extends Node

#var sounds_path = "res://music_and_sounds"

@export var hit : AudioStream
@export var jump : AudioStream
@export var water_bottle : AudioStream
@export var airdash : AudioStream
@export var lifemax : AudioStream
@export var plant_walking : AudioStream
@export var plant_attack : AudioStream
@export var alfy_attack : AudioStream
@export var pigbreak : AudioStream
@export var press_switch : AudioStream
@export var punch : AudioStream
@export var door_opening : AudioStream
@export var button_pressed : AudioStream
@export var slide_up : AudioStream
@export var item_retrieved : AudioStream

@onready var sound_players = get_children()

func play(sound_stream, pitch_scale = 1.0, volume_db = 0.0):
	for audio in sound_players:
		if not audio.playing:
			audio.volume_db = volume_db
			audio.stream = sound_stream
			if audio.stream == airdash:
				audio.pitch_scale = 0.4
			else:
				audio.pitch_scale = pitch_scale
			audio.play()
			return
