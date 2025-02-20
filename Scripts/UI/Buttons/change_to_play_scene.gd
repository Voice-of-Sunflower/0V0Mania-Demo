extends Node

func _on_play_button_pressed():
	if GlobalVariable.selected_level_path.is_empty():
		return
	else :
		get_tree().change_scene_to_file("res://Scenes/beatmap_ingame.tscn")
