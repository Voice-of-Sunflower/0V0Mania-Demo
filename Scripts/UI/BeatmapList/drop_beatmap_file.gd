extends Node

@export var osu_beatmap_converter: BeatmapConverter

const beatmaps_path = "./Beatmaps"
var the_beatmap_path: String
var beatmap_info: Dictionary = {}

func _ready() -> void:
	get_tree().root.files_dropped.connect(_on_files_dropped)

func _on_files_dropped(drop_files: PackedStringArray):
	var is_osu_beatmap: bool = false
	for drop_file in drop_files:
		## 读取osz文件
		if drop_file.get_extension() == "osz":
			is_osu_beatmap = true
			var beatmap_name: String = drop_file.get_file().get_basename()
			## 修复部分歌曲含有特殊字符文件夹不能创建的问题，拖放designant.这首曲的时候发现的问题
			var fix_beatmap_name: String = Utility.filter_invalid_symbol(beatmap_name)
			the_beatmap_path = beatmaps_path.path_join(fix_beatmap_name)
			
			if !DirAccess.open(beatmaps_path).dir_exists(fix_beatmap_name):
				DirAccess.open(beatmaps_path).make_dir(fix_beatmap_name)
			
			## 解压osz文件（有点难绷为什么还需要用到buffer来解压）
			Utility.zip_unzipper_with_ext(drop_file, the_beatmap_path, ["mp3", "osu", "jpg", "ogg"])
			## 保留原解压方法
			#var zip_reader = ZIPReader.new()
			#if zip_reader.open(drop_file) == 0:
				#for file_name in zip_reader.get_files():
					#var file_ext: String = file_name.get_extension()
					#if file_ext == "mp3" || file_ext == "osu" || file_ext == "jpg" || file_ext == "ogg":
						#var file_path: String = the_beatmap_path.path_join(file_name)
						#var file = FileAccess.open(file_path, FileAccess.WRITE)
						#var buffer = zip_reader.read_file(file_name)
						#file.store_buffer(buffer)
						#file.close()
			
			for file in DirAccess.open(the_beatmap_path).get_files():
				rename_file(the_beatmap_path.path_join(file))
			
			load_osu_beatmap_file(the_beatmap_path)
			
		## 读取pck文件
		elif drop_file.get_extension() == "pck":
			var file_name_with_ext: String = drop_file.get_file()
			var drop_file_path: String = drop_file.get_base_dir()
			DirAccess.open(drop_file_path).copy(drop_file, beatmaps_path.path_join(file_name_with_ext))
		
		## 其他格式不做处理
		else :
			return
		
	get_tree().reload_current_scene()

## 重命名音频文件和封面文件
func rename_file(file_path: String):
	match file_path.get_file():
		"audio.mp3":
			Utility.rename_file(file_path, "music.mp3")
		"audio.ogg":
			Utility.rename_file(file_path, "music.ogg")
	match file_path.get_extension():
		"jpg":
			Utility.rename_file(file_path, "cover.jpg")
		"png":
			Utility.rename_file(file_path, "cover.png")

## 加载osu文件并转换
func load_osu_beatmap_file(path: String):
	for osu_file in DirAccess.open(path).get_files():
		if osu_file.get_extension() == "osu":
			if osu_beatmap_converter.osu_file_converter(the_beatmap_path.path_join(osu_file)):
				generate_osu_beatmap_dir()

## 生成谱面信息文件
func generate_beatmap_info_json(info: Dictionary):
	var beatmap_info_path = the_beatmap_path.path_join("beatmap_info.json")
	var info_file = FileAccess.open(beatmap_info_path, FileAccess.WRITE)
	var convert_data: String = JSON.stringify(info)
	info_file.store_string(convert_data)
	info_file.close()

## 生成关卡文件夹并转录谱面
func generate_osu_beatmap_dir():
	if !FileAccess.file_exists(the_beatmap_path.path_join("beatmap_info.json")):
		generate_beatmap_info_json(osu_beatmap_converter.get_beatmap_info())
	
	osu_beatmap_converter.sort_note_group_time()
	osu_beatmap_converter.sort_hold_group_time()
	
	var level_path: String = the_beatmap_path.path_join(osu_beatmap_converter.level_name)
	if !DirAccess.open(the_beatmap_path).dir_exists(osu_beatmap_converter.level_name):
		DirAccess.open(the_beatmap_path).make_dir(osu_beatmap_converter.level_name)
	
	osu_beatmap_converter.save_beatmap_json(osu_beatmap_converter.note_array, false, level_path)
	osu_beatmap_converter.save_beatmap_json(osu_beatmap_converter.hold_array, true, level_path)
	osu_beatmap_converter.reset_note_data()
	osu_beatmap_converter.reset_beatmap_info()
