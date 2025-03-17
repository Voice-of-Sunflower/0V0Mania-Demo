extends Note

enum note_states {INIT, IS_HEAD}
var current_state = note_states.INIT

func _ready():
	init_other_node()
	check_note_track()
	
	PERFECT = 0
	MISS = 120
	current_time = Time.get_ticks_msec()
	
	is_auto_play = GlobalVariable.auto_play_mode

## 改进后使用 _unhandled_input 方法判定
func _unhandled_input(event):
	## 增加标识符比对，标识符相等才进行 note 判定
	var is_correct_index: bool = (current_note_index == IngameVariable.current_track_note_index[note_track - 1])
	if event.is_action_pressed("Key_" + str(note_track)) && is_correct_index:
		if current_state == note_states.IS_HEAD:
			GlobalVariable.hit_sound.play()
			note_judger.judge_rate(abs(get_elapsed_time() - time_difference))
			IngameVariable.current_track_note_index[note_track - 1] = current_note_index + 1
			get_parent().queue_free()

## 原来的方法在 _process 方法中判定（修改 check_note_track() 并替换第33行）
func _process(delta):
	elapsed_time = get_elapsed_time()
	
	if is_auto_play:
		if elapsed_time > time_difference:
			auto_play()
	else :
		if elapsed_time > time_difference - 75:
			current_state = note_states.IS_HEAD
		if elapsed_time > time_difference + 120:
			note_judger.judge_rate(MISS)
			IngameVariable.current_track_note_index[note_track - 1] = current_note_index + 1
			get_parent().queue_free()

## 原来的判断方式
func input_check(track: int):
	if Input.is_action_just_pressed("Key_" + str(track)):
		GlobalVariable.hit_sound.play()
		print(elapsed_time - time_difference)
		var time = abs(elapsed_time - time_difference)
		note_judger.judge_rate(time)
		get_parent().queue_free()

## 自动播放
func auto_play():
	note_judger.judge_rate(PERFECT)
	get_parent().queue_free()
