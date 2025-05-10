extends Node

@export var delete_dialog: CanvasLayer
@export var delete_hint: CanvasLayer
@export var delete_menu: PopupMenu
@export var export_script: Node

const beatmaps_path: String = "./Beatmaps/"

func _ready():
	GlobalVariable.show_delete_menu.connect(_on_delete_menu_visible)

## 删除选中按钮的内容（删除的方式是移动文件到系统垃圾桶中）
func delete():
	if GlobalVariable.selected_level_path.begins_with("res"):
		delete_hint.visible = true
		delete_dialog.visible = false
		return
	elif GlobalVariable.selected_beatmap_path.begins_with("res"):
		OS.move_to_trash(ProjectSettings.globalize_path(beatmaps_path.path_join(GlobalVariable.selected_beatmap_info["Name"]) + ".pck"))
		get_tree().reload_current_scene()
		return

	if !GlobalVariable.selected_level_path.is_empty():
		OS.move_to_trash(ProjectSettings.globalize_path(GlobalVariable.selected_level_path))
		get_tree().reload_current_scene()
	elif !GlobalVariable.selected_beatmap_path.is_empty():
		OS.move_to_trash(ProjectSettings.globalize_path(GlobalVariable.selected_beatmap_path))
		get_tree().reload_current_scene()

func _on_delete_menu_visible():
	delete_menu.position = get_viewport().get_mouse_position()
	delete_menu.visible = true

func _on_delete_button_pressed():
	delete_dialog.visible = true

func _on_delete_yes_pressed():
	delete()

func _on_delete_no_pressed():
	delete_dialog.visible = false

func _on_ok_button_pressed():
	delete_hint.visible = false

func _on_delete_menu_id_pressed(id):
	delete()
