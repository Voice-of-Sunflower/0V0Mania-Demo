extends Node

@export var chart_info: Node

var is_start: bool = false
var current_time: int
var pass_time: int
var audio_latency: int
var music_start_position: int

#var note_times: Array
#var note_tracks: Array
#var current_note: int = 0
#var next_note_time: int = 0

#var track_1_hit: bool = false
#var track_2_hit: bool = false
#var track_3_hit: bool = false
#var track_4_hit: bool = false

## note 的 rate 判断偏差 (单位为 ms)
enum rate_offset { MARVELOUS = 35, PERFECT = 50, GREAT = 80, GOOD = 100, MISS = 120 }

## hold 的 rate 判断偏差 (单位为 ms)
enum rate_offset_hold { MARVELOUS = 50, PERFECT = 80, GREAT = 100, GOOD = 150, MISS = 200 }

signal add_score(rate)

func _ready():
	music_start_position = GlobalVariable.selected_beatmap_info["Offset"]

## note判定部分
func judge_rate(time_difference) -> void:
	if time_difference <= rate_offset.MARVELOUS:
		add_score.emit(rate_offset.MARVELOUS)
	elif time_difference <= rate_offset.PERFECT:
		add_score.emit(rate_offset.PERFECT)
	elif time_difference <= rate_offset.GREAT:
		add_score.emit(rate_offset.GREAT)
	elif time_difference <= rate_offset.GOOD:
		add_score.emit(rate_offset.GOOD)
	elif time_difference > rate_offset.GOOD:
		add_score.emit(rate_offset.MISS)

## hold判定部分
func judge_rate_hold(time_difference) -> void:
	if time_difference <= rate_offset_hold.MARVELOUS:
		add_score.emit(rate_offset.MARVELOUS)
	elif time_difference <= rate_offset_hold.PERFECT:
		add_score.emit(rate_offset.PERFECT)
	elif time_difference <= rate_offset_hold.GREAT:
		add_score.emit(rate_offset.GREAT)
	elif time_difference <= rate_offset_hold.GOOD:
		add_score.emit(rate_offset.GOOD)
	elif time_difference > rate_offset_hold.GOOD:
		add_score.emit(rate_offset.MISS)

## 如果你想改进此方法，把 ”判断方法1“ 之前的部分移到_process(delta)函数中，再删去 func depercated_judge_method() 一句
func depercated_judge_method():
	pass
	##计时器 
	#if is_start:
		#pass_time = Time.get_ticks_msec() - current_time
		
		## 判定方法1 使用全局判断，后面note miss的部分不好写，摸了
		#if Input.is_action_just_pressed("Key_1"):
			#track1_judge()
		#
		#if Input.is_action_just_pressed("Key_2"):
			#track2_judge()
		#
		#if Input.is_action_just_pressed("Key_3"):
			#track3_judge()
		#
		#if Input.is_action_just_pressed("Key_4"):
			#track4_judge()

		#if pass_time > next_note_time - 120:
			#ote_hit_check()
## 判断方法1 检测是否能打击部分
#func note_hit_check():
	#var note_tracks_index = 0
	#for note_track in note_tracks[current_note]:
		#match note_track:
			#1:
				#track_1_hit = true
				#note_tracks_index += 1
			#2:
				#track_2_hit = true
				#note_tracks_index += 1
			#3:
				#track_3_hit = true
				#note_tracks_index += 1
			#4:
				#track_4_hit = true
				#note_tracks_index += 1
#
	#if note_tracks_index == note_tracks[current_note].size():
		#if current_note < note_times.size() - 1:
			#current_note += 1
			#next_note_time = note_times[current_note]

## 判定方法1 轨道判定部分
#func track1_judge():
	### 这里使用current_note - 1 是因为判定的时候current_note已经指向下一个note了
	#if track_1_hit:
		#var time_difference = abs(pass_time - note_times[current_note - 1])
		#print(time_difference)
		#judge_rate(time_difference)
		#track_1_hit = false
#
#func track2_judge():
	#if track_2_hit:
		#var time_difference = abs(pass_time - note_times[current_note - 1])
		#print(time_difference)
		#judge_rate(time_difference)
		#track_2_hit = false
#
#func track3_judge():
	#if track_3_hit:
		#var time_difference = abs(pass_time - note_times[current_note - 1])
		#print(time_difference)
		#judge_rate(time_difference)
		#track_3_hit = false
#
#func track4_judge():
	#if track_4_hit:
		#var time_difference = abs(pass_time - note_times[current_note - 1])
		#print(time_difference)
		#judge_rate(time_difference)
		#track_4_hit = false

func _on_wait_start_timeout():
	is_start = true
	current_time = Time.get_ticks_msec()
