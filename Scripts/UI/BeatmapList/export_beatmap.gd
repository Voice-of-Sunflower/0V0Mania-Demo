extends Node

@export var file_dialog: FileDialog

func export_packed_file(output_path: String):
	var packed_beatmaps_path: String = "res://Beatmaps".path_join(GlobalVariable.selected_beatmap_info["Name"])
	var origin_beatmaps_path: String = GlobalVariable.selected_beatmap_path
	
	var level_dirs = DirAccess.open(origin_beatmaps_path).get_directories()
	
	if FileAccess.file_exists(output_path.path_join(GlobalVariable.selected_beatmap_info["Name"]) + ".pck"):
		DirAccess.open(output_path).remove(GlobalVariable.selected_beatmap_info["Name"] + ".pck")
	
	var packer = PCKPacker.new()
	packer.pck_start(output_path.path_join(GlobalVariable.selected_beatmap_info["Name"]) + ".pck")
	packer.add_file(packed_beatmaps_path.path_join("music.mp3"), origin_beatmaps_path.path_join("music.mp3"))
	packer.add_file(packed_beatmaps_path.path_join("beatmap_info.json"), origin_beatmaps_path.path_join("beatmap_info.json"))
	packer.add_file(packed_beatmaps_path.path_join("cover.jpg"), origin_beatmaps_path.path_join("cover.jpg"))
	
	for level_name in level_dirs:
		var packed_level_path: String = packed_beatmaps_path.path_join(level_name)
		var origin_level_path: String = origin_beatmaps_path.path_join(level_name)
		packer.add_file(packed_level_path.path_join("beatmap_hold.json"), origin_level_path.path_join("beatmap_hold.json"))
		packer.add_file(packed_level_path.path_join("beatmap_note.json"), origin_level_path.path_join("beatmap_note.json"))
	packer.flush(true)

func _on_export_file_dialog_dir_selected(dir):
	export_packed_file(dir)

func _on_export_button_pressed():
	file_dialog.visible = true
