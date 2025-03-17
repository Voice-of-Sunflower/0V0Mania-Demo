extends BeatmapConverter

var level_name: String
var beatmap_offset: int = -1
var beatmap_bpm: int = 0
var music_author: String
var music_title: String

func osu_file_converter(file_path: String) -> bool:
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	var get_hit_object_info: bool = false
	var get_beatmap_info: bool = false
	var fix_offset: int = 0

	while !file.eof_reached():
		var line_text: String = file.get_line()
		
		## 检查是否为 Mania 模式
		if "Mode:" in line_text:
			var mode_line = line_text.split(":", false)
			if int(mode_line[1]) != 3:
				print("Unsupported beatmap mode.")
				reset_beatmap_info()
				return false
		
		## 检查是否为 4 Keys 
		if "CircleSize:" in line_text:
			var keys_line = line_text.split(":", false)
			if int(keys_line[1]) != 4:
				print("Unsupported keys.")
				reset_beatmap_info()
				return false
		
		## 获取关卡名
		if "Version:" in line_text && level_name.is_empty():
			var version_line = line_text.split(":", false)
			level_name = Utility.filter_invalid_symbol(version_line[1])
		
		## 获取音乐名
		if "Title:" in line_text && music_title.is_empty():
			var music_title_line: PackedStringArray = line_text.split(":", false)
			music_title = Utility.filter_invalid_symbol(music_title_line[1])
		
		## 获取作者名称
		if "Artist:" in line_text && music_author.is_empty():
			var music_author_line = line_text.split(":", false)
			music_author = Utility.filter_invalid_symbol(music_author_line[1])
		
		## 获取谱面起始延迟和BPM
		if "TimingPoints" in line_text:
			get_beatmap_info = true
			continue
		
		if get_beatmap_info && beatmap_offset == -1 && beatmap_bpm == 0:
			var offset_line = line_text.split(",", false)
			beatmap_offset = int(offset_line[0])
			beatmap_bpm = 60 * 1000 / float(offset_line[1])
			get_beatmap_info = false
		
		## 获取note物件
		if "HitObjects" in line_text:
			get_hit_object_info = true
			continue
		
		if get_hit_object_info:
			if line_text.is_empty():
				continue
			var object_info_line: PackedStringArray = line_text.split(":", false)
			var object_vaild_part = object_info_line[0].split(",", false)
			
			var object_track = floori(int(object_vaild_part[0]) * 4 / 512) + 1
			var object_start_time = int(object_vaild_part[2])
			var object_end_time = int(object_vaild_part[5])
			
			object_start_time -= beatmap_offset
			## 有些谱面note时间从time point前面开始，也就是开始时间是负数，不得不写一个延迟修正
			if object_start_time < 0 && fix_offset == 0:
				fix_offset = abs(object_start_time)
				beatmap_offset -= fix_offset
				object_start_time = 0
			
			## 根据物件是否有结束时间判断note类型
			if object_end_time == 0:
				if !note_group.has(object_start_time):
					note_group[object_start_time] = []
				
				note_group[object_start_time].append(object_track)
			else:
				object_end_time -= beatmap_offset
				
				if !hold_group.has(object_start_time):
					hold_group[object_start_time] = []
				
				if hold_group[object_start_time].size() < 1:
					hold_group[object_start_time].append([])
				hold_group[object_start_time][0].append(object_track)
				
				if hold_group[object_start_time].size() < 2:
					hold_group[object_start_time].append([])
				var hold_time = object_end_time - object_start_time
				hold_group[object_start_time][1].append(hold_time)
				
	get_hit_object_info = false
	return true

func get_beatmap_info() -> Dictionary:
	var beatmap_info: Dictionary = {"Name": music_title, "Author": music_author, "BPM": beatmap_bpm, "Offset": beatmap_offset}
	return beatmap_info

## 重置获取音符的信息
func reset_note_data():
	note_group.clear()
	hold_group.clear()
	note_array.clear()
	hold_array.clear()

## 重置谱面基础信息
func reset_beatmap_info():
	level_name = ""
	beatmap_offset = -1
	beatmap_bpm = 0
	music_author = ""
	music_title = ""
