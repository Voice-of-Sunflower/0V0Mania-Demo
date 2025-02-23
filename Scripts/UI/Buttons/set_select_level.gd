extends Node

@export var level_button: Button
var beatmap_path: String = GlobalVariable.selected_beatmap_path
var selected_level: String

## 获取选择关卡名称与文件夹路径
func _on_level_button_pressed():
	selected_level = level_button.text
	GlobalVariable.selected_level_name = level_button.text
	GlobalVariable.selected_level_path = beatmap_path.path_join(selected_level)
	GlobalVariable.selected_beatmap.set_play_button_visible()
