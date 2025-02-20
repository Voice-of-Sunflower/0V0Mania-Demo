extends Node

@export var music_title: Label
@export var music_bpm: Label
@export var music_len: Label
@export var music_artwork_rect: TextureRect

@export var preview_bgm: AudioStreamPlayer

const music_title_text: String = "{0} - {1}"
const music_bpm_text: String = "BPM: {0}"
const music_length_text: String = "Length: {0}"

var beatmap_info: Dictionary
var music_stream: AudioStream

func _ready():
	GlobalVariable.card_info_change.connect(_on_card_info_change)
	GlobalVariable.preview_music.connect(_on_preview_bgm_start)

func _on_card_info_change(is_artwork_exist: bool):
	beatmap_info = GlobalVariable.selected_beatmap_info
	music_stream = GlobalVariable.selected_beatmap_music
	if music_stream:
		var length = int(music_stream.get_length())
		music_len.text = music_length_text.format({"0": convert_time(length)})
	else :
		music_len.text = "No Audio"
	
	music_title.text = music_title_text.format({"0": beatmap_info["Author"], "1": beatmap_info["Name"]})
	music_bpm.text = music_bpm_text.format({"0": beatmap_info["BPM"]})
	
	var image_texture = ImageTexture.new()
	image_texture.set_image(GlobalVariable.beatmap_artwork)
	music_artwork_rect.texture = image_texture

func _on_preview_bgm_start():
	if GlobalVariable.selected_beatmap_music == null:
		music_fade_out()
		await get_tree().create_timer(1.5).timeout
		preview_bgm.stop()
	
	if preview_bgm.playing:
		if preview_bgm.stream == GlobalVariable.selected_beatmap_music:
			return
		else :
			music_fade_out()
			await get_tree().create_timer(1.5).timeout
			preview_bgm.stop()
			preview_bgm.stream = GlobalVariable.selected_beatmap_music
			preview_bgm.play()
			music_fade_in()
	else :
		preview_bgm.stream = GlobalVariable.selected_beatmap_music
		preview_bgm.play()
		music_fade_in()

func music_fade_out() -> void:
	var tween: Tween
	tween = create_tween()
	tween.tween_property(preview_bgm, "volume_db", -80, 2)

func music_fade_in() -> void:
	var tween: Tween
	tween = create_tween()
	tween.tween_property(preview_bgm, "volume_db", 0, 2)

func convert_time(time: int):
	var minutes = time / 60
	var seconds = time % 60
	return "%d : %02d" % [minutes, seconds]
