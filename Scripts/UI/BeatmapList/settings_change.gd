extends Node

@export var setting_dialog: CanvasLayer

@export var fall_speed_value: Label
@export var master_volume_value: Label
@export var bgm_volume_value: Label
@export var sfx_volume_value: Label
@export var global_offset_value: LineEdit

@export var fall_speed_slider: HSlider
@export var master_volume_slider: HSlider
@export var bgm_volume_slider: HSlider
@export var sfx_volume_slider: HSlider

@export var key_1_button: Button
@export var key_2_button: Button
@export var key_3_button: Button
@export var key_4_button: Button

@export var language_button: Button

@export var sfx_sound_player: AudioStreamPlayer

func _on_setting_button_pressed():
	## 从文件获取设置
	fall_speed_value.text = str(GlobalSettings.fall_speed)
	fall_speed_slider.value = GlobalSettings.fall_speed
	
	master_volume_value.text = str(GlobalSettings.master_volume * 100)
	master_volume_slider.value = GlobalSettings.master_volume
	
	bgm_volume_value.text = str(GlobalSettings.bgm_volume * 100)
	bgm_volume_slider.value = GlobalSettings.bgm_volume
	
	sfx_volume_value.text = str(GlobalSettings.sfx_volume * 100)
	sfx_volume_slider.value = GlobalSettings.sfx_volume
	
	global_offset_value.text = str(GlobalSettings.judge_offset)
	
	key_1_button.text = GlobalSettings.key_1_config
	key_2_button.text = GlobalSettings.key_2_config
	key_3_button.text = GlobalSettings.key_3_config
	key_4_button.text = GlobalSettings.key_4_config
	
	language_button.text = GlobalSettings.language
	
	setting_dialog.visible = true

func _on_ok_button_pressed():
	## 保存并更新文件
	GlobalSettings.fall_speed = fall_speed_slider.value
	GlobalSettings.master_volume = master_volume_slider.value
	GlobalSettings.bgm_volume = bgm_volume_slider.value
	GlobalSettings.sfx_volume = sfx_volume_slider.value
	GlobalSettings.judge_offset = int(global_offset_value.text)
	
	GlobalSettings.key_1_config = key_1_button.text
	GlobalSettings.key_2_config = key_2_button.text
	GlobalSettings.key_3_config = key_3_button.text
	GlobalSettings.key_4_config = key_4_button.text
	
	GlobalSettings.language = language_button.text
	
	GlobalSettings.update_setting()
	
	setting_dialog.visible = false

func _on_fall_speed_slider_value_changed(value):
	fall_speed_value.text = str(value)

func _on_master_volume_slider_value_changed(value):
	master_volume_value.text = str(value * 100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_bgm_volume_slider_value_changed(value):
	bgm_volume_value.text = str(value * 100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), linear_to_db(value))

func _on_sfx_volume_slider_value_changed(value):
	sfx_volume_value.text = str(value * 100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	sfx_sound_player.play()
