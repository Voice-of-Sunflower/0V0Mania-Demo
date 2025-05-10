extends Node

@export var music_item: Button
@export var level_name: Label

@export var music_file_loader: Node

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
	## 先取消上一个点击的谱面的play按钮显示
	if GlobalVariable.selected_beatmap:
		GlobalVariable.selected_beatmap.set_play_button_invisible()
	## 再将目前选择的谱面赋值
	GlobalVariable.selected_beatmap = music_item
	
	## 重置选择的关卡信息
	GlobalVariable.selected_level_path = ""
	GlobalVariable.selected_level_name = ""
	
	## 将目前选择的谱面路径和谱面信息赋值到全局变量中
	beatmap_path = music_item.beatmap_path
	GlobalVariable.selected_beatmap_path = beatmap_path
	GlobalVariable.selected_beatmap_info = beatmap_info
	
	## 将谱面封面赋值到全局变量中
	GlobalVariable.beatmap_cover = music_item.cover_image

	music_file_loader.file_load(beatmap_path)

	GlobalVariable.preview_music.emit()
	GlobalVariable.card_info_change.emit(music_item.is_cover_exist)
	GlobalVariable.button_visible_change.emit()
	GlobalVariable.load_levels.emit()

	
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
	
func _on_music_item_gui_input(event):
	if event is InputEventMouse:
		if event.button_mask == MOUSE_BUTTON_RIGHT:
			GlobalVariable.show_edit_menu.emit()
