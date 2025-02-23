extends Node

@export var stop_menu: CanvasLayer

@export var master_slider: HSlider
@export var bgm_slider: HSlider
@export var sfx_slider: HSlider

@export var master_volume: Label
@export var bgm_volume: Label
@export var sfx_volume: Label

@export var stop_timer: Timer

var pause_time: int
var pause_duration: int

func _unhandled_input(event):
	if event.is_action_pressed("key_stop_play"):
		pause_game()

func pause_game() -> void:
	get_tree().paused = true
	master_volume.text = str(GlobalSettings.master_volume * 100)
	master_slider.value = GlobalSettings.master_volume
	
	bgm_volume.text = str(GlobalSettings.bgm_volume * 100)
	bgm_slider.value = GlobalSettings.bgm_volume
	
	sfx_volume.text = str(GlobalSettings.sfx_volume * 100)
	sfx_slider.value = GlobalSettings.sfx_volume
	
	pause_time = Time.get_ticks_msec()
	stop_menu.visible = true

func _on_stop_button_pressed():
	pause_game()

## 音量调整部分
func _on_master_volume_slider_value_changed(value):
	master_volume.text = str(value * 100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_bgm_volume_slider_value_changed(value):
	bgm_volume.text = str(value * 100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), linear_to_db(value))

func _on_sfx_volume_slider_value_changed(value):
	sfx_volume.text = str(value * 100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

## 底部的三个按钮
func _on_continue_button_pressed():
	stop_timer.start()
	stop_menu.visible = false

func _on_retry_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_back_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/beatmap_list_ui.tscn")

func _on_stop_timer_timeout():
	## 获取暂停时长修正time单例获取的时间
	pause_duration = Time.get_ticks_msec() - pause_time
	GlobalVariable.continue_play.emit(pause_duration)
	get_tree().paused = false
