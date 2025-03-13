extends Note

@export var hold_texture: ColorRect
@export var hold: Node2D

var press_time: int
var release_time: int
var hold_duration: int

var is_held: bool = false
var is_hold_start: bool = true
var is_hold_end: bool = false
var is_hold_break: bool = false

enum hold_states { INIT, IS_HEAD, IS_HOLDING, IS_NOT_HOLD, IS_BREAK }

@export var current_state = hold_states.INIT

func _ready():
	init_other_node()
	check_note_track()
	
	PERFECT = 0
	GOOD = 150
	MISS = 200
	
	hold_duration = hold.duration
	current_time = Time.get_ticks_msec()
	
	is_auto_play = GlobalVariable.auto_play_mode

## 改进后使用 _unhandled_input 方法判定
func _unhandled_input(event):
	## 增加标识符比对，标识符相等才进行 note 判定
	var is_correct_index: bool = (current_hold_index == IngameVariable.current_track_note_index[note_track - 1])
	if event.is_action_pressed("Key_" + str(note_track)) && is_correct_index:
		input_check_improve_press_part()
	if event.is_action_released("Key_" + str(note_track)):
		input_check_improve_release_part()

## 原来的方法在 _process 方法中判定（但是那部分有点忘记了，应该是在修改 check_note_track() 后移动到第49行）
func _process(delta):
	elapsed_time = get_elapsed_time()
	
	if is_auto_play:
		if elapsed_time > time_difference:
			auto_play()
	else :
		## hold第一次判断，判断位置为头部，如果在时间点 ±150ms 内未击中则判定为miss
		if elapsed_time > time_difference - 75 && current_state == hold_states.INIT:
			current_state = hold_states.IS_HEAD
		elif elapsed_time > time_difference + 150 && current_state == hold_states.IS_HEAD:
			current_state = hold_states.IS_NOT_HOLD
			hold_texture.color = miss_color
		## 在hold结尾处于松开按键的状态下判定为miss
		elif elapsed_time > time_difference + hold_duration :
			match current_state:
				hold_states.IS_NOT_HOLD:
					note_judger.judge_rate_hold(MISS)
					IngameVariable.current_track_note_index[note_track - 1] += 1
					get_parent().queue_free()
				hold_states.IS_HOLDING:
					GlobalVariable.hit_sound.play()
					note_judger.judge_rate_hold(PERFECT)
					IngameVariable.current_track_note_index[note_track - 1] += 1
					get_parent().queue_free()

## 原来的判定方式
func input_check(track: int):
	## hold第一次判断，判断位置为头部，如果在时间点 ±150ms 内未击中则判定为miss
	if Input.is_action_just_pressed("Key_" + str(track)) && !is_held:
		GlobalVariable.hit_sound.play()
		is_held = true
		press_time = Time.get_ticks_msec()
		if is_hold_start:
			var time = abs(elapsed_time - time_difference)
			note_judger.judge_rate_hold(time)
		is_hold_start = false
		hold_texture.color = origin_color
	
	## 因为hold的特殊性，按下超时判断只能写在这里
	elif is_hold_start && elapsed_time > time_difference + 150:
		is_hold_start = false
		is_hold_break = true
		note_judger.judge_rate_hold(MISS)
		hold_texture.color = miss_color
	
	## hold第二次判定，判断位置为hold过程中，松开按键后先判定为miss，松开后再继续按回延续到尾部判定为good；
	## 从头按住按键在结束前 150ms 内松开判定为perfect+
	if is_held:
		if !Input.is_action_pressed("Key_" + str(track)):
			release_time = Time.get_ticks_msec()
			if !is_hold_break && hold_duration - (release_time - press_time) < 150:
				note_judger.judge_rate_hold(PERFECT)
				IngameVariable.current_track_note_index[note_track - 1] += 1
				get_parent().queue_free()
			hold_texture.color = miss_color
			is_held = false
			is_hold_break = true
		if is_hold_end:
			if is_hold_break:
				note_judger.judge_rate_hold(GOOD)
			else:
				note_judger.judge_rate_hold(PERFECT)
			IngameVariable.current_track_note_index[note_track - 1] += 1
			get_parent().queue_free()

## 改进的判断方式，分为两个部分，这是press部分
func input_check_improve_press_part() -> void:
	## 使用状态机匹配进行判定
	match current_state:
		hold_states.IS_HEAD:
			press_time = Time.get_ticks_msec()
			GlobalVariable.hit_sound.play()
			note_judger.judge_rate_hold(abs(get_elapsed_time() - time_difference))
			current_state = hold_states.IS_HOLDING
		## _input()无法识别到此状态，移动到_process()中
		#hold_states.IS_HOLDING:
			#if get_elapsed_time() > time_difference + hold_duration:
				#GlobalVariable.hit_sound.play()
				#note_judger.judge_rate_hold(PERFECT)
				#IngameVariable.current_track_note_index[note_track - 1] += 1
				#get_parent().queue_free()
		hold_states.IS_NOT_HOLD:
			current_state = hold_states.IS_BREAK
		hold_states.IS_BREAK:
			hold_texture.color = origin_color
			if get_elapsed_time() > time_difference + hold_duration:
				GlobalVariable.hit_sound.play()
				note_judger.judge_rate_hold(GOOD)
				IngameVariable.current_track_note_index[note_track - 1] += 1
				get_parent().queue_free()

## 改进的判断方式，分为两个部分，这是release部分
func input_check_improve_release_part() -> void:
	match current_state:
		hold_states.IS_HOLDING:
			release_time = Time.get_ticks_msec()
			if hold_duration - (release_time - press_time) > 150:
				current_state = hold_states.IS_NOT_HOLD
				hold_texture.color = miss_color
			else :
				GlobalVariable.hit_sound.play()
				note_judger.judge_rate_hold(PERFECT)
				IngameVariable.current_track_note_index[note_track - 1] += 1
				get_parent().queue_free()
		hold_states.IS_BREAK:
			if hold_duration - (release_time - press_time) > 150:
				hold_texture.color = miss_color
			else :
				GlobalVariable.hit_sound.play()
				note_judger.judge_rate_hold(GOOD)
				IngameVariable.current_track_note_index[note_track - 1] += 1
				get_parent().queue_free()

## 自动播放
func auto_play():
	if is_hold_start:
		note_judger.judge_rate_hold(PERFECT)
		is_hold_start = false
	
	if elapsed_time > time_difference + hold_duration:
		note_judger.judge_rate_hold(PERFECT)
		get_parent().queue_free()
