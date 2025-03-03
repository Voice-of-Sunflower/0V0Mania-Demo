extends Node

@export var bpm_timer: Timer
@export var bgm_offset_timer: Timer
@export var sound: AudioStreamPlayer
@export var bgm: AudioStreamPlayer
@export var base_attribute: Node
@export var latency_text: Label

var beat_time: float
var press_time: float
var current_time: float
var is_press_time_start = false
var time_difference
var audio_latency_compensation = 0

## 这个脚本用于 test_level 中的节拍器
func _ready():
	reset_offset_time()

func _process(delta):
	if is_press_time_start:
		## 使用叠加delta的方式增加按键时间，这种方式会受到帧率影响存在10-30ms的误差
		# press_time += delta
		
		## 使用Time单例增加时间，可以精确到1ms，但可能对系统消耗有点大
		press_time = Time.get_ticks_msec() - current_time + base_attribute.offset
	
	if Input.is_action_just_pressed("Key_1"):
		audio_latency_compensation = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
		sound.play()
		time_difference_judge()

# 时间差判断
func time_difference_judge():
	time_difference = ceili(press_time - beat_time - audio_latency_compensation * 1000)
	if time_difference >= 300:
		time_difference = time_difference - base_attribute.per_beat_second * 1000

	# 0-40ms内为perfect，40-75ms内为great，75-100ms内为good，大于100ms为miss
	if abs(time_difference) <= 40:
		print("Perfect!")
	elif abs(time_difference) <= 75:
		print("Great!")
	elif abs(time_difference) <= 100:
		print("Good!")
	else :
		print("Miss!")

	latency_text.text = str(time_difference)

func reset_offset_time():
	press_time = base_attribute.offset

func reset_beat_time():
	beat_time = 0

## 信号区
func _on_start_button_pressed():
	is_press_time_start = true
	current_time = Time.get_ticks_msec()
	bpm_timer.start()
	bgm_offset_timer.start()

func _on_bpm_timer_timeout():
	beat_time += base_attribute.per_beat_second * 1000

func _on_press_button_pressed():
	time_difference_judge()

func _on_set_offset_setting_offset():
	reset_offset_time()

func _on_stop_button_pressed():
	is_press_time_start = false
	bpm_timer.stop()
	bgm.stop()
	reset_offset_time()
	reset_beat_time()
	audio_latency_compensation = 0
