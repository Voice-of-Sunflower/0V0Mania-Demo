extends BaseNote
class_name HoldNote

# 自动播放的判断时间变量组
var head_auto_judge_time_msec: int
var tail_auto_judge_time_msec: int

var head_judge_start_time_msec: int ## 单位为毫秒(ms)，计算值为: 时间差 - GOOD判定
var head_judge_time_msec: int
var head_judge_end_time_msec: int ## 单位为毫秒(ms)，计算值为: 时间差 + MISS判定
var tail_judge_start_time_msec: int ## 单位为毫秒(ms)，计算值为: 时间差 + hold时长 - GREAT判定
var tail_judge_end_time_msec: int ## 单位为毫秒(ms)，计算值为: 时间差 + hold时长

enum States {INIT, HIT_ON, HOLDING, HOLD_END, BREAK, NOT_HOLD, HIT_OFF, AUTO_HEAD, AUTO_HOLD, RECYCLED}
var current_state: States = States.INIT

var duration: int = 0 # hold的持续时间

func _enter_tree() -> void:
	init_material()
	init_texture()
	set_process(true)
	set_process_unhandled_key_input(false)

func init_variables(note_i: int, track_i: int, note_t: int, dura: int, time_dif: float):
	current_state = States.INIT
	
	note_index = note_i
	note_time_stamp = note_t
	track_index = track_i
	duration = dura
	
	time_difference = time_dif
	head_judge_start_time_msec = note_time_stamp + time_difference * 1000 - judge_manager.GREAT_HOLD
	head_judge_time_msec = note_time_stamp + time_difference * 1000
	head_judge_end_time_msec = note_time_stamp + time_difference * 1000 + judge_manager.GOOD_HOLD
	tail_judge_start_time_msec = note_time_stamp + time_difference * 1000 + duration - judge_manager.GOOD_HOLD
	tail_judge_end_time_msec = head_judge_time_msec + duration

func calculate_length():
	## 长度计算公式为: 持续时间 / 1000 * 下落速度
	length = float(duration) / 1000 * speed
	note_texture.size.y = length

func set_to_auto_mode():
	auto_play = true
	current_state = States.AUTO_HEAD
	head_auto_judge_time_msec = note_time_stamp + time_difference * 1000
	tail_auto_judge_time_msec = note_time_stamp + time_difference * 1000 + duration

func reset_times():
	head_auto_judge_time_msec = 0
	tail_auto_judge_time_msec = 0
	
	head_judge_start_time_msec = 0
	head_judge_time_msec = 0
	head_judge_end_time_msec = 0
	tail_judge_start_time_msec = 0
	tail_judge_end_time_msec = 0
	
	current_state = States.RECYCLED
	duration = 0
	note_texture.size.y = 50

func recycle():
	track_node.remove_child(self)
	note_object_pool.recycle_note(NoteObjectPool.NoteType.HOLD, self)

func note_end_process(rating_or_offset: int):
	## 状态改变
	current_state = States.HIT_OFF
	judge_manager.get_rating_hold(rating_or_offset)
	
	## 状态处理
	set_process_unhandled_key_input(false)
	set_process(false)
	track_node.current_note_index = note_index + 1
	#track_node.unlock_next_note()
	recycle()

func set_hold_length(color: Color):
	note_material.set_shader_parameter("base_color", color)
	var note_length_ratio: float = float(tail_judge_end_time_msec - elasped_time) / duration
	note_material.set_shader_parameter("dissolve_amount", note_length_ratio)

func _process(delta: float) -> void:
	elasped_time = time_manager.elapsed_time
	
	position.y = init_pos_y + float(elasped_time - note_time_stamp) / 1000 * speed
	if position.y > 720 + note_texture.size.y + speed * 0.2:
		note_end_process(judge_manager.MISS_HOLD)
	
	match current_state:
		States.AUTO_HEAD:
			if elasped_time >= head_auto_judge_time_msec:
				current_state = States.AUTO_HOLD
				judge_manager.get_rating_hold(judge_manager.MARVELOUS_HOLD)
		States.AUTO_HOLD:
			set_hold_length(origin_color)
			if elasped_time >= tail_auto_judge_time_msec:
				note_end_process(judge_manager.MARVELOUS_HOLD)
		States.INIT:
			if elasped_time >= head_judge_start_time_msec:
				current_state = States.HIT_ON
				set_process_unhandled_key_input(true)
		States.HIT_ON:
			if elasped_time >= head_judge_end_time_msec:
				current_state = States.NOT_HOLD
				judge_manager.get_rating_hold(judge_manager.MISS_HOLD)
		States.HOLDING:
			note_material.set_shader_parameter("base_color", origin_color)
			set_hold_length(origin_color)
			
			if elasped_time >= tail_judge_end_time_msec:
				note_end_process(judge_manager.MARVELOUS_HOLD)
		States.NOT_HOLD:
			note_material.set_shader_parameter("base_color", miss_color)
			
			if elasped_time >= tail_judge_end_time_msec:
				note_end_process(judge_manager.MISS_HOLD)
		States.BREAK:
			note_material.set_shader_parameter("base_color", origin_color)
			set_hold_length(origin_color)
			
			if elasped_time >= tail_judge_end_time_msec:
				note_end_process(judge_manager.GOOD_HOLD)

#func start_judge():
	#var judge_start_time: float = time_difference - (float(JudgeManager.Rating.GREAT) / 1000)
	#await get_tree().create_timer(judge_start_time).timeout
	#current_state = States.HIT_ON
#
#func miss_end_note():
	#var judge_end_time: float = time_difference + (float(JudgeManager.Rating.MISS) / 1000) + (duration / 1000)
	#await get_tree().create_timer(judge_end_time).timeout
	#match current_state:
		#States.NOT_HOLD:
			#judge_manager.get_rating(JudgeManager.Rating.MISS)
		#States.HOLDING:
			#judge_manager.get_rating(JudgeManager.Rating.PERFECT)
		#States.BREAK:
			#judge_manager.get_rating(JudgeManager.Rating.GOOD)
	#
	#current_state = States.HIT_OFF

func _unhandled_key_input(event: InputEvent) -> void:
	var key_event: InputEventKey = event
	if key_event.is_action_pressed("Key_" + str(track_index)) and note_index == track_node.current_note_index:
		match current_state:
			States.HIT_ON:
				note_material.set_shader_parameter(&"pulse_intensity", 1.0)
				var hit_time: int = elasped_time - head_judge_time_msec
				var hit_offset: int = absi(hit_time)
				judge_manager.get_rating_hold(hit_offset)
				current_state = States.HOLDING
			States.NOT_HOLD:
				note_material.set_shader_parameter(&"pulse_intensity", 1.0)
				current_state = States.BREAK
	
	if key_event.is_action_released("Key_" + str(track_index)):
		note_material.set_shader_parameter(&"pulse_intensity", 0.0)
		match current_state:
			States.HOLDING:
				if elasped_time >= tail_judge_start_time_msec:
					note_end_process(judge_manager.MARVELOUS_HOLD)
				else :
					current_state = States.NOT_HOLD
			States.BREAK:
				if elasped_time >= tail_judge_start_time_msec:
					note_end_process(judge_manager.GOOD_HOLD)
				else :
					current_state = States.NOT_HOLD

func _exit_tree() -> void:
	set_process(false)
	set_process_unhandled_key_input(false)
