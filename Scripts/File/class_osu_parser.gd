extends RefCounted
class_name OSUManiaParser

# 解析结果结构
var music_title: String
var artist: String
var level_name: String
var author: String
var source: String

var mode: int = 3
var circle_size: float = 4.0
var first_timing_point: float = -1.0 # 音乐起始延迟
var bpm_array: PackedFloat32Array
var notes: Dictionary = { 1: [], 2: [], 3: [], 4:[] }  # 存储所有音符
var long_notes: Dictionary = { 1: [], 2: [], 3: [], 4:[] }  # 存储所有长键音符

# 解析 OSU 谱面文件
func parse_file(path: String) -> bool:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("无法打开文件: " + path)
		return false
	
	# 重置解析结果
	music_title = ""
	artist = ""
	level_name = ""
	author = ""
	source = ""
	mode = 3
	circle_size = 4.0
	first_timing_point = -1.0
	notes.clear()
	long_notes.clear()
	
	var current_section: String = ""
	
	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		
		if mode != 3 or circle_size != 4.0:
			push_error("不支持的谱面格式 或 不支持的键位数量")
			return false
		
		# 跳过空行和注释
		if line.is_empty() or line.begins_with("//"):
			continue
		
		# 检测章节标题
		if line.begins_with("[") and line.ends_with("]"):
			current_section = line.substr(1, line.length() - 2).to_lower()
			continue
		
		# 根据当前章节处理内容
		match current_section:
			"general":
				_parse_general(line)
			"metadata":
				_parse_metadata(line)
			"difficulty":
				_parse_difficulty(line)
			"timingpoints":
				_parse_timing_points(line)
			"hitobjects":
				_parse_hit_objects(line)
	
	file.close()
	return true

func parse_metadata(path: String) -> bool:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("无法打开文件: " + path)
		return false
	
	var current_section: String = ""
	
	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		
		# 跳过空行和注释
		if line.is_empty() or line.begins_with("//"):
			continue
		
		# 检测章节标题
		if line.begins_with("[") and line.ends_with("]"):
			current_section = line.substr(1, line.length() - 2).to_lower()
			continue
		
		# 根据当前章节处理内容
		match current_section:
			"metadata":
				_parse_metadata(line)
	
	file.close()
	return true

func get_bpm_array() -> PackedFloat32Array:
	return bpm_array

# 解析 [General] 部分
func _parse_general(line: String):
	var parts: PackedStringArray = line.split(":")
	if parts.size() < 2:
		return
	
	var key: String = parts[0].strip_edges().to_lower()
	var value: String = parts[1].strip_edges()
	
	if key == "mode":
		mode = int(value)
		# 如果不是mania模式，发出警告
		if mode != 3:
			push_error("不支持的谱面格式")

# 解析 [Metadata] 部分
func _parse_metadata(line: String):
	var parts: PackedStringArray = line.split(":")
	if parts.size() < 2:
		return
	
	var key: String = parts[0].strip_edges().to_lower()
	var value: String = parts[1].strip_edges()
	
	if key == "title":
		music_title = Utility.filter_invalid_symbol(value)
	
	if key == "artist":
		artist = Utility.filter_invalid_symbol(value)
	
	if key == "version":
		level_name = Utility.filter_invalid_symbol(value)
	
	if key == "creator":
		author = Utility.filter_invalid_symbol(value)
	
	if key == "source":
		source = Utility.filter_invalid_symbol(value)

# 解析 [Difficulty] 部分
func _parse_difficulty(line: String):
	var parts: PackedStringArray = line.split(":")
	if parts.size() < 2:
		return
	
	var key: String = parts[0].strip_edges().to_lower()
	var value: String = parts[1].strip_edges()
	
	if key == "circlesize":
		circle_size = int(value)
		# 在mania模式中，CircleSize表示键位数量
		if mode == 3:
			print("键位数量: %d" % circle_size)
		if circle_size != 4:
			push_error("不支持的键位数量")

# 解析 [TimingPoints] 部分
func _parse_timing_points(line: String):
	var point_tempo: float
	
	var parts = line.split(",")
	if parts.size() >= 1:
		if first_timing_point == 0.0:
			first_timing_point = float(parts[0].strip_edges())
		
		point_tempo = float(parts[1].strip_edges())
	
	if point_tempo > 0:
		var bpm: float = _tempo_to_bpm(point_tempo)
		bpm_array.append(bpm)

# 解析 [HitObjects] 部分 (mania模式专用)
func _parse_hit_objects(line: String):
	var parts = line.split(",")
	if parts.size() < 5:
		return
	
	# 确保是mania模式
	if mode != 3:
		return
	
	# 提取基本数据
	var x: int = int(parts[0].strip_edges())
	var time: int = int(parts[2].strip_edges())
	
	# 计算长键列位置 (基于键位数量)
	var column: int = _calculate_column(x, circle_size)
	
	# 判断是否为长键音符 (有6个或更多数据)
	if parts.size() >= 6:
		# 解析长键结束时间
		var end_time_str: String = parts[5].split(":")[0].strip_edges()
		var end_time: int = int(end_time_str)
		
		# 存储普通音符
		if end_time == 0:
			if not notes.has(column + 1):
				notes[column + 1] = []
			(notes[column + 1] as Array).append(time)
		# 存储长键音符
		else :
			if not long_notes.has(column + 1):
				long_notes[column + 1] = []
			(long_notes[column + 1] as Array).append([time, end_time])
		

# 计算音符所在的列 (mania模式)
func _calculate_column(x: int, key_count: int) -> int:
	# 计算列位置
	# 算法为: floor(x * 键位总数 / 512)
	var column: int = floori(x * key_count / 512)
	
	# 确保列在有效范围内
	return clampi(column, 0, key_count - 1)

# 将速度值转换为 BPM
func _tempo_to_bpm(tempo: float) -> float:
	var bpm: float = 60000.0 / float(tempo)
	bpm = snappedf(bpm, 0.01)
	return bpm

# 获取解析结果
func get_results() -> Dictionary:
	return {
		"notes": notes,
		"long_notes": long_notes
	}

func get_level_name() -> String:
	return level_name

func get_author() -> String:
	return author
