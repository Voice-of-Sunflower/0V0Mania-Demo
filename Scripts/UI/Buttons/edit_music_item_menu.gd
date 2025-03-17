extends Node

@export var edit_beatmap_info_script: Node

@export var menu: PopupMenu

@export var edit_dialog: CanvasLayer
@export var delete_dialog: CanvasLayer
@export var export_dialog: FileDialog

func _ready():
	GlobalVariable.show_edit_menu.connect(_on_menu_visible)

func _on_menu_visible():
	menu.position = get_viewport().get_mouse_position()
	menu.visible = true

func _on_beatmap_edit_menu_id_pressed(id):
	match id:
		0:
			edit_beatmap_info_script.edit_info()
			edit_dialog.visible = true
		1:
			delete_dialog.visible = true
		2:
			export_dialog.visible = true
