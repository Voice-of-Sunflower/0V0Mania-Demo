extends Node
class_name AudioManager

@export var bgm_player: AudioStreamPlayer
@export var hit_sound_player: AudioStreamPlayer

var audio_stream: AudioStream
var audio_length: float

func _ready() -> void:
	set_process(false)

func set_audio_stream(stream: AudioStream):
	audio_stream = stream
	audio_length = audio_stream.get_length()
	bgm_player.stream = audio_stream

func clear_audio_stream():
	audio_stream = null
	audio_length = 0.0
	bgm_player.stream = null

func set_audio_stream_by_path(path: String):
	match path.get_extension():
		"mp3":
			audio_stream = AudioStreamMP3.load_from_file(path)
		"ogg":
			audio_stream = AudioStreamOggVorbis.load_from_file(path)
	
	bgm_player.stream = audio_stream

func play_hit_sound():
	hit_sound_player.play()

func audio_fade_out() -> Tween:
	var tween: Tween = create_tween()
	tween.tween_property(bgm_player, "volume_linear", 0.0, 6.0)
	return tween

func get_audio_latency() -> int:
	var lantency: float = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	var lantency_msec: int = lantency * 1000
	return lantency_msec
