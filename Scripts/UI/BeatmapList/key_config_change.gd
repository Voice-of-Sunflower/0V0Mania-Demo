extends Node

enum edit_keys_config { NONE, KEY_1, KEY_2, KEY_3, KEY_4 }
var edit_key
var change_key: String

@export var key_1_button: Button
@export var key_2_button: Button
@export var key_3_button: Button
@export var key_4_button: Button

func _input(event):
	if !edit_key == edit_keys_config.NONE:
		if event is InputEventKey:
			change_key = event.as_text_physical_keycode()
			match_key_and_change(event)
			edit_key = edit_keys_config.NONE
	
func _on_key_1_config_button_pressed():
	edit_key = edit_keys_config.KEY_1

func _on_key_2_config_button_pressed():
	edit_key = edit_keys_config.KEY_2

func _on_key_3_config_button_pressed():
	edit_key = edit_keys_config.KEY_3

func _on_key_4_config_button_pressed():
	edit_key = edit_keys_config.KEY_4

func match_key_and_change(input_event: InputEvent):
	match edit_key:
		edit_keys_config.KEY_1:
			set_key_config("Key_1", input_event)
			key_1_button.text = change_key
		edit_keys_config.KEY_2:
			set_key_config("Key_2", input_event)
			key_2_button.text = change_key
		edit_keys_config.KEY_3:
			set_key_config("Key_3", input_event)
			key_3_button.text = change_key
		edit_keys_config.KEY_4:
			set_key_config("Key_4", input_event)
			key_4_button.text = change_key

func set_key_config(action_name: StringName, input_event: InputEvent):
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, input_event)
