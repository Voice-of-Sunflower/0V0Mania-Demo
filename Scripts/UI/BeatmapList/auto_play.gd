extends Node

@export var auto_play_button: Button

func _on_auto_play_button_toggled(toggled_on: bool):
	if toggled_on:
		auto_play_button.text = "Auto Play : ON"
		GlobalVariable.auto_play_mode = true
	else :
		auto_play_button.text = "Auto Play : OFF"
		GlobalVariable.auto_play_mode = false
