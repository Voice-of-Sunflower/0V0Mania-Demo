extends Node
class_name BeatmapConverter

var note_group: Dictionary = {}
var hold_group: Dictionary = {}
var note_array: Array = []
var hold_array: Array = []

func sort_note_group_time():
	## dictionary转为array
	for note_time in note_group:
		note_array.append({ "time": note_time, "track": note_group[note_time] })
	## 根据时间重新排序
	note_array.sort_custom(func(a, b): return a["time"] < b["time"])
	return note_array

func sort_hold_group_time():
	## 与上面同理
	for note_time in hold_group:
		hold_array.append({ "time": note_time, "track": hold_group[note_time][0], "length": hold_group[note_time][1] })
	hold_array.sort_custom(func(a, b): return a["time"] < b["time"])
	return hold_array

## 根据类型区分储存文件
func save_beatmap_json(chart_data: Array, is_hold: bool, path: String):
	var chart_json_path: String
	
	if !is_hold:
		chart_json_path = path.path_join("beatmap_note.json")
	else :
		chart_json_path = path.path_join("beatmap_hold.json")
	
	var file = FileAccess.open(chart_json_path, FileAccess.WRITE) 
	var convert_data = JSON.stringify(chart_data, "\t")
	file.store_string(convert_data)
	file.close()
