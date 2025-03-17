extends Node

## 跳转至游戏游玩场景
func _on_play_button_pressed():
	if GlobalVariable.selected_level_path.is_empty():
		return
	else :
		get_tree().change_scene_to_file("res://Scenes/beatmap_ingame.tscn")
