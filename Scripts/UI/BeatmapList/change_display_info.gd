extends Node

@export var music_item: Button
@export var level_name: Label

#var music_title_label: Label
#var music_bpm_label: Label
#var music_length_label: Label
#var music_artwork_rect: TextureRect
#
#var add_level_button: Button
#var beatmap_info_edit_button: Button
#
#const music_title_text: String = "{0} - {1}"
#const music_bpm_text: String = "BPM: {0}"
#const music_length_text: String = "Length: {0}"

var beatmap_info: Dictionary
var beatmap_path: String

func _on_music_item_pressed():
	if GlobalVariable.selected_beatmap:
		GlobalVariable.selected_beatmap.set_play_button_invisible()
	GlobalVariable.selected_beatmap = music_item
	GlobalVariable.selected_level_path = ""
	GlobalVariable.selected_level_name = ""
	beatmap_path = music_item.beatmap_path
	
	GlobalVariable.selected_beatmap_path = beatmap_path
	GlobalVariable.selected_beatmap_info = beatmap_info
	GlobalVariable.beatmap_artwork = music_item.artwork_image
	if FileAccess.file_exists(beatmap_path.path_join("music.mp3")):
		var audio_file_data = FileAccess.get_file_as_bytes(beatmap_path.path_join("music.mp3"))
		var audio_stream: AudioStream = AudioStreamMP3.new()
		audio_stream.loop = false
		audio_stream.data = audio_file_data
		GlobalVariable.selected_beatmap_music = audio_stream
	else :
		GlobalVariable.selected_beatmap_music = null
	
	GlobalVariable.card_info_change.emit(music_item.is_artwork_exist)
	GlobalVariable.button_visible_change.emit()
	GlobalVariable.load_levels.emit()
	GlobalVariable.preview_music.emit()
	
	#add_level_button.visible = true
	#beatmap_info_edit_button.visible = true

	#music_title_label.text = music_title_text.format({"0": beatmap_info["Author"], "1": beatmap_info["Name"]})
	#music_bpm_label.text = music_bpm_text.format({"0": beatmap_info["BPM"]})
	#
	#if music_item.is_artwork_exist:
		#var image_texture = ImageTexture.new()
		#image_texture.set_image(music_item.artwork_image)
		#music_artwork_rect.texture = image_texture
	
func _on_music_item_loading_finished():
	beatmap_info = music_item.beatmap_info
	
