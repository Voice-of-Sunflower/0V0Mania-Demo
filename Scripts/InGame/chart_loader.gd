extends Node

@export var info_script: Node

var beatmap_info: Dictionary = GlobalVariable.selected_beatmap_info
var beatmap_level_path: String = GlobalVariable.selected_level_path

signal loading_finish

func _ready():
	info_script.music_start_position = beatmap_info["Offset"]
	load_beatmap_file()

func load_beatmap_file():
	var hold_file = FileAccess.open(beatmap_level_path.path_join("beatmap_hold.json"), FileAccess.READ)
	var note_file = FileAccess.open(beatmap_level_path.path_join("beatmap_note.json"), FileAccess.READ)
	
	var hold_data: String = hold_file.get_as_text()
	var note_data: String = note_file.get_as_text()
	hold_file.close()
	note_file.close()
	
	var hold_data_convert = JSON.parse_string(hold_data)
	var note_data_convert = JSON.parse_string(note_data)
	info_script.note_array = note_data_convert
	info_script.hold_array = hold_data_convert
	loading_finish.emit()
