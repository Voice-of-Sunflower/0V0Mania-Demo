extends Node

@export var edit_level_info_dialog: CanvasLayer
@export var select_audio_file_dialog: FileDialog
@export var select_midi_file_dialog: FileDialog
@export var select_cover_file_dialog: FileDialog

@export var audio_file_text_edit: LineEdit
@export var beatmap_file_edit: LineEdit
@export var cover_file_edit: LineEdit
@export var level_name_edit: LineEdit

@export var beatmap_converter: Node

var beatmap_path: String
var beatmap_info: Dictionary

func _on_add_level_button_pressed():
	beatmap_path = GlobalVariable.selected_beatmap_path
	edit_level_info_dialog.visible = true
	
	if FileAccess.file_exists(beatmap_path.path_join("music.mp3")):
		audio_file_text_edit.text = beatmap_path.path_join("music.mp3")
	else :
		audio_file_text_edit.text = ""
	
	if FileAccess.file_exists(beatmap_path.path_join("cover.jpg")):
		cover_file_edit.text = beatmap_path.path_join("cover.jpg")
	elif FileAccess.file_exists(beatmap_path.path_join("cover.png")):
		cover_file_edit.text = beatmap_path.path_join("cover.png")
	else :
		cover_file_edit.text = ""

func _on_cancel_button_pressed():
	edit_level_info_dialog.visible = false

func _on_ok_button_pressed():
	if audio_file_text_edit.text.is_empty():
		return
	if cover_file_edit.text.is_empty():
		return
	if !level_name_edit.text.is_empty() && !beatmap_file_edit.text.is_empty():
		create_level_dictory()
	
	edit_level_info_dialog.visible = false
	get_tree().reload_current_scene()

func _on_import_audio_button_pressed():
	select_audio_file_dialog.visible = true

func _on_import_beatmap_button_pressed():
	select_midi_file_dialog.visible = true

func _on_impoet_cover_button_pressed():
	select_cover_file_dialog.visible = true

func _on_audio_file_dialog_file_selected(source_path: String):
	var target_path = beatmap_path.path_join("music.mp3")
	
	DirAccess.copy_absolute(source_path, target_path)
	audio_file_text_edit.text = target_path

func _on_midi_file_dialog_file_selected(source_path: String):
	var target_path = beatmap_path.path_join("beatmap.mid")
	
	DirAccess.copy_absolute(source_path, target_path)
	beatmap_file_edit.text = target_path

func _on_cover_file_dialog_file_selected(source_path: String):
	var target_path: String
	if source_path.get_extension() == "jpg":
		target_path = beatmap_path.path_join("cover.jpg")
	elif source_path.get_extension() == "png":
		target_path = beatmap_path.path_join("cover.png")
	
	DirAccess.copy_absolute(source_path, target_path)
	cover_file_edit.text = target_path

func create_level_dictory():
	if !DirAccess.open(beatmap_path).dir_exists(level_name_edit.text):
		DirAccess.open(beatmap_path).make_dir(level_name_edit.text)
	
	var midi_file: MidiData = ResourceLoader.load(beatmap_file_edit.text)
	beatmap_converter.set_bpm(GlobalVariable.selected_beatmap_info["BPM"])
	beatmap_converter.import_beatmap_midi(midi_file)
	
	var note_array: Array = beatmap_converter.sort_note_group_time()
	var hold_array: Array = beatmap_converter.sort_hold_group_time()
	
	beatmap_converter.save_beatmap_json(note_array, false, beatmap_path.path_join(level_name_edit.text))
	beatmap_converter.save_beatmap_json(hold_array, true, beatmap_path.path_join(level_name_edit.text))
