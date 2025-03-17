extends BeatmapConverter

var beatmap_bpm: int
signal loading_finished

func set_bpm(bpm: int):
	beatmap_bpm = bpm

func import_beatmap_midi(beatmap_midi: MidiData):
	## 谱面note分组根据midi track区分，如track 1为旋律，track 2为鼓组。
	## CAUTION: hold 的 track 必须有 B4 音符，编写midi时需要注意。
	## ATTENTION: 还有一个注意点，hold 的 track 解析存在一定的问题，
	## 尽量一条 track 只写一边轨道(如果起始位置相同，长度相同的 hold 可以合成一条 track)，
	## 否则大概率会出现解析不通过的问题。

	for track in range(1, beatmap_midi.tracks.size()):
		## 使用 A5 音符作为是否为hold track的判断
		var is_hold_track: bool = false
		var note_start_time: int
		var note_end_time: int
		
		var init_delay = beatmap_midi.tracks[track].get_offset_in_seconds()
		var us_per_beat: int = 0

		for event in beatmap_midi.tracks[track].events:
			var tempo = event as MidiData.Tempo
			if tempo != null:
				us_per_beat = tempo.us_per_beat
			else :
				us_per_beat = int(60 / float(beatmap_bpm) * 1000000)

			init_delay += beatmap_midi.header.convert_to_seconds(us_per_beat, event.delta_time)
			
			## 检测音符头，获取音符时间和音高储存在note组中
			if event is MidiData.NoteOn:
				if event.note == 59:
					is_hold_track = true
				## 1. 用array储存排序(效率低，弃用)
				#var note_time = int(init_delay * 1000)
				#var note_track = event.note - 59
				#
				#var time_is_exist = false
				#for check_note in note_array:
					#if check_note["time"] == note_time:
						#check_note["track"].append(note_track)
						#time_is_exist = true
						#break
				#
				#if !time_is_exist:
					#note_array.append({"time": note_time, "track": [note_track]})

				## 2. 先用dictionary储存，再转为array排序
				note_start_time = int(init_delay * 1000)
				if !note_group.has(note_start_time) && !is_hold_track:
					note_group[note_start_time] = []

				if !hold_group.has(note_start_time) && is_hold_track:
					hold_group[note_start_time] = []

				## 60对应C5，从上往下转化为note track 4，往后类似
				## C5 -> track 4; C#5 -> track 3; D5 -> track 2; D#5 -> track 1
				if !is_hold_track:
					note_group[note_start_time].append(abs(event.note - 64))
				else:
					if hold_group[note_start_time].size() < 1:
						hold_group[note_start_time].append([])
					hold_group[note_start_time][0].append(abs(event.note - 64))
			
			if event is MidiData.NoteOff && is_hold_track:
				note_end_time = int(init_delay * 1000)
				if hold_group[note_start_time].size() < 2:
					hold_group[note_start_time].append([])
				var hold_time = note_end_time - note_start_time
				hold_group[note_start_time][1].append(hold_time)

#func export_note_array():
	#if !note_array.is_empty():
		#chart_info.note_array = note_array
		#loading_finished.emit()
#
#func export_hold_array():
	#if !hold_array.is_empty():
		#chart_info.hold_array = hold_array

#func load_chart_json():
	#var chart_json_path = "res://Charts/chart.json"
	#var file = FileAccess.open(chart_json_path, FileAccess.READ)
	#var data_string: String
	#
	#data_string = file.get_as_text()
	#file.close()
	#
	#var json = JSON.new()
	#var error = json.parse_string(data_string)
	#if error == OK:
		#var data_received = json.data
		#if typeof(data_received) == TYPE_ARRAY:
			#return data_received
	#else :
		#return 0
