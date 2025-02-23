extends Node

@export var delete_dialog: CanvasLayer

func _on_delete_button_pressed():
	delete_dialog.visible = true

## 删除选中按钮的内容（删除的方式是移动文件到系统垃圾桶中）
func _on_delete_yes_pressed():
	if !GlobalVariable.selected_level_path.is_empty():
		OS.move_to_trash(ProjectSettings.globalize_path(GlobalVariable.selected_level_path))
		get_tree().reload_current_scene()
	elif !GlobalVariable.selected_beatmap_path.is_empty():
		OS.move_to_trash(ProjectSettings.globalize_path(GlobalVariable.selected_beatmap_path))
		get_tree().reload_current_scene()
	delete_dialog.visible = false
	
func _on_delete_no_pressed():
	delete_dialog.visible = false
