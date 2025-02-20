extends Node

@export var pause_button: Button
@export var preview_bgm: AudioStreamPlayer
@export var auto_play_button: Button

var is_bgm_play: bool = false

func _ready():
	GlobalVariable.preview_music.connect(_on_preview_bgm_start)
	
	## 音乐暂停
func _on_preview_bgm_start():
	is_bgm_play = true
	pause_button.text = "||"

func _on_pause_button_pressed():
	if preview_bgm.stream == null:
		return
	
	if is_bgm_play:
		preview_bgm.stream_paused = true
		pause_button.text = "▶"
		is_bgm_play = !is_bgm_play
	else :
		preview_bgm.stream_paused = false
		pause_button.text = "||"
		is_bgm_play = !is_bgm_play

## 自动游玩
func _on_auto_play_button_toggled(toggled_on):
	if toggled_on:
		auto_play_button.text = "Auto Play : ON"
		GlobalVariable.auto_play_mode = true
	else :
		auto_play_button.text = "Auto Play : OFF"
		GlobalVariable.auto_play_mode = false

## 退出游戏
func _on_quit_button_pressed():
	get_tree().quit()
