extends Node

@export var chart_loader: Node
@export var chart_info: Node
@export var note_obj: PackedScene
@export var hold_obj: PackedScene

@export var track1: Node
@export var track2: Node
@export var track3: Node
@export var track4: Node

@export var spawn_timer: Timer
@export var wait_start_timer: Timer

var fall_time: float = 1
var is_start_spawn: bool = false
var is_end: bool = false
var current_time: int
var pass_time: int
var pause_duration: int = 0

var note_times: Array
var note_tracks: Array
var current_note: int = 0
var next_note_time: int

var hold_times: Array
var hold_tracks: Array
var hold_lengths: Array
var current_hold: int = 0
var next_hold_time: int

var judge_line_position: int = 515
var fall_position: int
var timer_difference: float

signal is_end_play

func _ready():
	## 获取下落到判定的时间差
	timer_difference = wait_start_timer.wait_time - spawn_timer.wait_time
	GlobalVariable.continue_play.connect(_on_continue_game)

func _process(delta):
	if is_start_spawn:
		pass_time = Time.get_ticks_msec() - current_time - pause_duration

		if current_note < note_times.size():
			if pass_time > next_note_time:
				spawn_note()
		
		if current_hold < hold_times.size():
			if  pass_time > next_hold_time:
				spawn_hold()

	if (current_note >= note_times.size()) && (current_hold >= hold_times.size()) && !is_end:
		is_start_spawn = false
		is_end = true
		is_end_play.emit()

func spawn_note() -> void:
	for note_track in note_tracks[current_note]:
		add_note_to_track(note_track, false, -1)

	if current_note < (note_times.size() - 1):
		next_note_time = note_times[current_note + 1]

	current_note += 1

func spawn_hold() -> void:
	var index = 0
	for note_track in hold_tracks[current_hold]:
		add_note_to_track(note_track, true, index)
		index += 1
	
	if current_hold < (hold_times.size() - 1):
		next_hold_time = hold_times[current_hold + 1]
	
	current_hold += 1

## 获取轨道信息并添加到轨道中
func add_note_to_track(note_track: int, is_hold_spawn: bool, note_track_index: int) -> void:
	match note_track:
		1:
			if !is_hold_spawn:
				var note = init_note()
				track1.add_child(note)
			else :
				var hold = init_hold(note_track_index)
				track1.add_child(hold)
		2:
			if !is_hold_spawn:
				var note = init_note()
				track2.add_child(note)
			else :
				var hold = init_hold(note_track_index)
				track2.add_child(hold)
		3:
			if !is_hold_spawn:
				var note = init_note()
				track3.add_child(note)
			else :
				var hold = init_hold(note_track_index)
				track3.add_child(hold)
		4:
			if !is_hold_spawn:
				var note = init_note()
				track4.add_child(note)
			else :
				var hold = init_hold(note_track_index)
				track4.add_child(hold)

## 实例化note
func init_note():
	var note: Node2D = note_obj.instantiate()
	fall_position = judge_line_position - (note.speed * timer_difference)
	note.position.y = fall_position - note.origin_length
	return note

## 实例化hold，index变量用于获取音符的时间长度
func init_hold(index: int):
	var hold: Node2D = hold_obj.instantiate()
	var calculated_length: int = float(hold_lengths[current_hold][index]) / 1000 * hold.speed
	hold.length = calculated_length
	hold.duration = hold_lengths[current_hold][index]
	fall_position = judge_line_position - (hold.speed * timer_difference)
	hold.position.y = fall_position - calculated_length
	return hold

func _on_spawn_timer_timeout():
	is_start_spawn = true
	current_time = Time.get_ticks_msec()

func _on_continue_game(time: int):
	pause_duration += time
	
## 获取生成信息
func _on_chart_loader_loading_finish():
	note_times = chart_info.split_note_times(chart_info.note_array)
	note_tracks = chart_info.split_note_tracks(chart_info.note_array)
	
	hold_times = chart_info.split_note_times(chart_info.hold_array)
	hold_tracks = chart_info.split_note_tracks(chart_info.hold_array)
	hold_lengths = chart_info.split_hold_lengths(chart_info.hold_array)
