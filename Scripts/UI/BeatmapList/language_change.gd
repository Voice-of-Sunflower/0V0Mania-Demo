extends Node

@export var language_button: Button
@export var menu: PopupMenu

func _on_setting_button_pressed():
	language_button.text = TranslationServer.get_locale()

func _on_language_config_button_pressed():
	menu.visible = true
	menu.position = get_viewport().get_mouse_position()

func _on_language_menu_id_pressed(id):
	match id:
		0:
			TranslationServer.set_locale("en")
		1:
			TranslationServer.set_locale("zh")
	
	language_button.text = TranslationServer.get_locale()
