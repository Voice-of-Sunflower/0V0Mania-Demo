extends BaseNote
class_name TapNote

var auto_judge_time_msec: int

var judge_start_time_msec: int ## 单位为毫秒(ms)
var judge_time_msec: int
var judge_end_time_msec: int ## 单位为毫秒(ms)

## 控制下落的补间动画
#var fall_tween: Tween # 备用方案，不使用

enum States {INIT, HIT_ON, HIT_OFF, AUTO, RECYCLED}
var current_state: States = States.INIT

func _enter_tree() -> void:
	init_material()
	init_texture()
	set_process(true)
	set_process_unhandled_key_input(false)
	length = note_texture.size.y

func init_variables(note_i: int, track_i: int, note_t: int, time_dif: float):
	current_state = States.INIT
	
	note_index = note_i
	note_time_stamp = note_t
	track_index = track_i
	
	time_difference = time_dif
	judge_start_time_msec = note_time_stamp + time_difference * 1000 - judge_manager.GREAT_TAP
	judge_time_msec = note_time_stamp + time_difference * 1000
	judge_end_time_msec = note_time_stamp + time_difference * 1000 + judge_manager.MISS_TAP

func set_to_auto_mode():
	auto_play = true
	auto_judge_time_msec = note_time_stamp + time_difference * 1000
	current_state = States.AUTO

func reset_times():
	auto_judge_time_msec = 0
	
	judge_start_time_msec = 0
	judge_time_msec = 0
	judge_end_time_msec = 0
	
	current_state = States.RECYCLED

func recycle():
	track_node.remove_child(self)
	note_object_pool.recycle_note(NoteObjectPool.NoteType.TAP, self)

func note_end_process(rating_or_offset: int):
	## 状态更改
	current_state = States.HIT_OFF
	judge_manager.get_rating(rating_or_offset)
	
	## 状态处理
	set_process_unhandled_key_input(false)
	set_process(false)
	track_node.current_note_index = note_index + 1
	recycle()

func _process(delta: float) -> void:
	elasped_time = time_manager.elapsed_time
	
	position.y = init_pos_y + float(elasped_time - note_time_stamp) / 1000 * speed
	if position.y > 720 + speed * 0.2:
		note_end_process(judge_manager.MISS_TAP)
	
	match current_state:
		States.AUTO:
			if elasped_time >= auto_judge_time_msec:
				note_end_process(judge_manager.MARVELOUS_TAP)
		States.INIT:
			if elasped_time >= judge_start_time_msec:
				current_state = States.HIT_ON
				set_process_unhandled_key_input(true)
		States.HIT_ON:
			if elasped_time >= judge_end_time_msec:
				note_end_process(judge_manager.MISS_TAP)

func _unhandled_key_input(event: InputEvent) -> void:
	var key_event: InputEventKey = event
	if key_event.is_action_pressed("Key_" + str(track_index)) and note_index == track_node.current_note_index:
		if current_state == States.HIT_ON:
			var hit_time = elasped_time - judge_time_msec
			var hit_offset: int = absi(hit_time)
			note_end_process(hit_offset)

func _exit_tree() -> void:
	set_process(false)
	set_process_unhandled_key_input(false)
