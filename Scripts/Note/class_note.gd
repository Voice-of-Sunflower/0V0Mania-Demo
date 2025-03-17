extends Node
class_name Note

var origin_color: Color = Color.DARK_GRAY
var miss_color: Color = Color.DIM_GRAY

var current_note_index: int
var current_hold_index: int

var current_time: int
var elapsed_time: int
var pause_duration: int = 0

var wait_start_timer: Timer
var note_spawn_timer: Timer
var time_difference: int

var note_judger: Node
var note_track: int

var PERFECT: int
var GREAT: int
var GOOD: int
var MISS: int

var is_auto_play: bool = false

func _init():
	GlobalVariable.continue_play.connect(_on_continue_game)

func init_other_node():
	wait_start_timer = get_tree().get_first_node_in_group("wait_start_timer")
	note_spawn_timer = get_tree().get_first_node_in_group("note_spawn_timer")
	note_judger = get_tree().get_first_node_in_group("note_judger")
	
	## 计算歌曲开始与音符生成的时间差，用于音符判定
	time_difference = (wait_start_timer.wait_time - note_spawn_timer.wait_time) * 1000 + note_judger.audio_latency

func check_note_track():
	match get_node("../..").name:
		"Track1":
			note_track = 1
			# input_check(1)
		"Track2":
			note_track = 2
			# input_check(2)
		"Track3":
			note_track = 3
			# input_check(3)
		"Track4":
			note_track = 4
			# input_check(4)

func input_check(track: int):
	pass

## 获取已经经过的时间
func get_elapsed_time() -> int:
	return Time.get_ticks_msec() - current_time - note_judger.music_start_position + GlobalSettings.judge_offset - pause_duration

## 计时从暂停到继续的时间
func _on_continue_game(time: int):
	pause_duration += time
