extends Node
class_name GameTime

@export_category("Timers")
@export var generate_timer: Timer
@export var music_start_timer: Timer
@export var pause_wait_timer: Timer

@export_category("Managers")
@export var ui_manager: InGameUI
@export var track_manager: TrackManager
@export var game_manager: GameManager
@export var audio_manager: AudioManager
@export var judge_manager: JudgeManager

var time_difference: float
var time_difference_msec: int

var start_time: int
var elapsed_time: int
var judge_time: int
var audio_offset: int

var pause_time: int
var continue_time: int
var pause_offset: int

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	elapsed_time = Time.get_ticks_msec() - start_time - audio_offset - pause_offset
	judge_time = elapsed_time - time_difference

## 音频延迟补偿
func get_audio_latency_fix() -> int:
	return (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()) * 1000

func get_timer_time_difference():
	time_difference = music_start_timer.wait_time - generate_timer.wait_time
	time_difference_msec = time_difference * 1000

func _on_game_pause():
	pause_time = Time.get_ticks_msec()
	set_process(false)

func _on_game_continue():
	pause_wait_timer.start()
	
	if game_manager.current_game_state != GameManager.GameState.PAUSE:
		return
	
	continue_time = Time.get_ticks_msec()
	pause_offset += continue_time - pause_time - get_audio_latency_fix()
	set_process(true)

func _on_generate_timer_timeout() -> void:
	start_time = Time.get_ticks_msec()
	audio_offset = get_audio_latency_fix()
	set_process(true)
	
	track_manager.start_generate.emit()

func _on_bgm_timer_timeout() -> void:
	var lantency: int = audio_manager.get_audio_latency()
	judge_manager.music_offset -= lantency
	
	audio_manager.bgm_player.play()
	ui_manager.set_process(true)

func _on_game_manager_start_game() -> void:
	generate_timer.start()
	music_start_timer.start()

func _on_data_loader_loading_finished() -> void:
	get_timer_time_difference()
