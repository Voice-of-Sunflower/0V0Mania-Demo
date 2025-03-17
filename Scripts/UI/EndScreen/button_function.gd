extends Node

## 返回界面
func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/beatmap_list_ui.tscn")

## 重试本局游戏
func _on_retry_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/beatmap_ingame.tscn")
