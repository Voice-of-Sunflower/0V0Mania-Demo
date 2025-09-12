extends Control
class_name NoteTrack

@export var tap_note_scene: PackedScene = preload("res://Scenes/tap_note.tscn")
@export var hold_note_scene: PackedScene = preload("res://Scenes/hold_note.tscn")

@export var game_manager: GameManager
@export var time_manager: GameTime
@export var track_manager: TrackManager
@export var judge_manager: JudgeManager
@export var note_pool: NoteObjectPool

@export var judge_line_pos: int = 635

var start_time: int
var elapsed_time: int ## 用于note生成
var judge_time: int ## 用于判定音符index递增

## note生成分化变量
var current_generate_note_index: int
var current_generate_tap_index: int
var current_generate_hold_index: int
var hold_generate_finish: bool = false
var tap_generate_finish: bool = false

## tap、hold相关变量
var tap_time: Array
var hold_time: Array
var note_count: int
var current_note_index: int:
	set(value):
		current_note_index = value
		finished_game()

## 评级判断相关变量
var track_index: int
var time_difference: float ## (单位为秒) 生成开始时与歌曲开始时的时间差 + 歌曲开头有声音时的时间差
var music_offset: float ## 音乐开始延迟

func _ready() -> void:
	track_manager.start_generate.connect(_on_start_generate)
	set_process(false)
	get_track_index()

func _on_start_generate():
	check_array_is_empty()
	set_process(true)

func _process(delta: float) -> void:
	elapsed_time = time_manager.elapsed_time
	
	## 生成tap note
	if not tap_generate_finish:
		if elapsed_time >= tap_time[current_generate_tap_index]:
			generate_tap_note()
	
	## 生成hold note
	if not hold_generate_finish:
		if elapsed_time >= hold_time[current_generate_hold_index][0]:
			generate_hold_note()

func init_tap_note():
	var note_obj: TapNote = note_pool.return_note(NoteObjectPool.NoteType.TAP)
	var fall_pos: int = judge_line_pos - (note_obj.speed * time_difference)
	var note_time_stamp: int = tap_time[current_generate_tap_index]
	
	note_obj.init_nodes(judge_manager, note_pool, self, time_manager)
	note_obj.init_variables(current_generate_note_index, track_index, note_time_stamp, time_difference)
	note_obj.init_start_position(fall_pos)
	
	return note_obj

func init_hold_note():
	var note_obj: HoldNote = note_pool.return_note(NoteObjectPool.NoteType.HOLD)
	var fall_pos: int = judge_line_pos - (note_obj.speed * time_difference)
	var note_time_stamp: int = hold_time[current_generate_hold_index][0]
	var hold_duration: int = hold_time[current_generate_hold_index][1] - hold_time[current_generate_hold_index][0]
	
	note_obj.init_nodes(judge_manager, note_pool, self, time_manager)
	note_obj.init_variables(current_generate_note_index, track_index, note_time_stamp, hold_duration, time_difference)
	note_obj.calculate_length()
	note_obj.init_start_position(fall_pos)
	
	return note_obj

func generate_tap_note():
	var note_obj: TapNote = init_tap_note()
	note_obj.name = &"TapNote" + str(current_generate_note_index)
	
	if track_manager.auto_play_mode:
		note_obj.set_to_auto_mode()
	
	add_child(note_obj)
	current_generate_tap_index += 1
	current_generate_note_index += 1
	check_array_boundary()

func generate_hold_note():
	var note_obj: HoldNote = init_hold_note()
	note_obj.name = &"HoldNote" + str(current_generate_note_index)
	
	if track_manager.auto_play_mode:
		note_obj.set_to_auto_mode()
	
	add_child(note_obj)
	current_generate_hold_index += 1
	current_generate_note_index += 1
	check_array_boundary()

func check_array_boundary():
	if current_generate_tap_index == tap_time.size():
		tap_generate_finish = true
	if current_generate_hold_index == hold_time.size():
		hold_generate_finish = true
	
	if tap_generate_finish and hold_generate_finish:
		set_process(false)

func finished_game():
	if current_note_index >= note_count:
		track_manager.play_completed.emit()

func check_array_is_empty():
	if tap_time.is_empty():
		tap_generate_finish = true
	if hold_time.is_empty():
		hold_generate_finish = true

func reset():
	current_generate_tap_index = 0
	current_generate_hold_index = 0
	current_note_index = 0
	tap_time.clear()
	hold_time.clear()

func get_track_index():
	track_index = int(name.trim_prefix("Track"))
