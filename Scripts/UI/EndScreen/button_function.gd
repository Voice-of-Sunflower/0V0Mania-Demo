extends Node


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/beatmap_list_ui.tscn")

func _on_retry_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/beatmap_ingame.tscn")
