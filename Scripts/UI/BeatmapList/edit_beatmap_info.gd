extends Node

@export var edit_dialog: CanvasLayer
@export var delete_hint: CanvasLayer

@export var music_name_editor: LineEdit
@export var music_author_editor: LineEdit
@export var music_bpm_editor: LineEdit
@export var music_offset_editor: LineEdit

@export var load_beatmap_list: Node

const beatmaps_path: String = "./Beatmaps/"

var origin_path: String
var beatmap_info: Dictionary
var is_edit: bool = false

## 获取谱面原信息
func edit_info():
	is_edit = true
	beatmap_info = GlobalVariable.selected_beatmap_info
	
	music_name_editor.text = beatmap_info["Name"]
	music_author_editor.text = beatmap_info["Author"]
	music_bpm_editor.text = str(beatmap_info["BPM"])
	music_offset_editor.text = str(beatmap_info["Offset"])
	
	origin_path = music_name_editor.text

## 保存修改信息
func check_and_save_info():
	if music_name_editor.text.is_empty():
		return
	if music_author_editor.text.is_empty():
		return
	if music_bpm_editor.text.is_empty():
		return
	if music_offset_editor.text.is_empty():
		return
	
	var music_name: String = music_name_editor.text
	var music_author: String = music_author_editor.text
	var music_bpm: int = int(music_bpm_editor.text)
	var music_offset: int = int(music_offset_editor.text)
	
	if !DirAccess.open(beatmaps_path).dir_exists(music_name) && !is_edit:
		DirAccess.open(beatmaps_path).make_dir(music_name)
	
	## 对谱面文件夹重命名
	if is_edit:
		var rename_path = beatmaps_path.path_join(music_name)
		Utility.rename_dir(origin_path, rename_path)
		is_edit = false
	
	## 将谱面信息保存成文件写入本地
	var beatmap_info: Dictionary = {"Name": music_name, "Author": music_author, "BPM": music_bpm, "Offset": music_offset}
	var beatmap_info_file_path = beatmaps_path.path_join(music_name).path_join("beatmap_info.json")
	Utility.json_save(beatmap_info_file_path, beatmap_info)

func _on_add_button_pressed():
	edit_dialog.visible = true

func _on_dialog_cancel_pressed():
	is_edit = false
	edit_dialog.visible = false

func _on_dialog_ok_pressed():
	check_and_save_info()
	get_tree().reload_current_scene()
	edit_dialog.visible = false

func _on_edit_button_pressed():
	if GlobalVariable.selected_beatmap_path.begins_with("res"):
		delete_hint.visible = true
		return
	edit_info()
	edit_dialog.visible = true
