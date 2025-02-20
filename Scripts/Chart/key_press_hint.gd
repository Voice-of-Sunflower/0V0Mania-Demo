extends Node
@export var key1: Panel
@export var key2: Panel
@export var key3: Panel
@export var key4: Panel

@export var key_1_label: Label
@export var key_2_label: Label
@export var key_3_label: Label
@export var key_4_label: Label

@export var key_1_hint: Label
@export var key_2_hint: Label
@export var key_3_hint: Label
@export var key_4_hint: Label

func _ready():
	key_1_label.text = GlobalSettings.key_1_config
	key_2_label.text = GlobalSettings.key_2_config
	key_3_label.text = GlobalSettings.key_3_config
	key_4_label.text = GlobalSettings.key_4_config
	
	key_1_hint.text = GlobalSettings.key_1_config
	key_2_hint.text = GlobalSettings.key_2_config
	key_3_hint.text = GlobalSettings.key_3_config
	key_4_hint.text = GlobalSettings.key_4_config
	
	GlobalVariable.enter_beatmap_play_scene.emit()

func _unhandled_input(event):
	if !GlobalVariable.auto_play_mode:
		if event.is_action_pressed("Key_1"):
			key1.visible = true
		if event.is_action_released("Key_1"):
			key1.visible = false
		
		if event.is_action_pressed("Key_2"):
			key2.visible = true
		if event.is_action_released("Key_2"):
			key2.visible = false
		
		if event.is_action_pressed("Key_3"):
			key3.visible = true
		if event.is_action_released("Key_3"):
			key3.visible = false
		
		if event.is_action_pressed("Key_4"):
			key4.visible = true
		if event.is_action_released("Key_4"):
			key4.visible = false
