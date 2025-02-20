extends Node

@export var wait_start: Timer
@export var note_spawn: Timer
@export var bgm: AudioStreamPlayer
@export var note_judger: Node

var audio_latency: int

func _ready():
	bgm.stream = GlobalVariable.selected_beatmap_music
	note_spawn.wait_time += float(GlobalVariable.selected_beatmap_info["Offset"] / 1000)

func _on_play_button_button_down():
	wait_start.start()
	note_spawn.start()

func _on_wait_start_timeout():
	audio_latency = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	note_judger.audio_latency = audio_latency
	bgm.play()
