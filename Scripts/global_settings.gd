extends Node

var fall_speed: float = 30.0

var master_volume: float = 0.8
var bgm_volume: float = 0.8
var sfx_volume: float = 0.8

var judge_offset: int = 0

var key_1_config: String = "D"
var key_2_config: String = "F"
var key_3_config: String = "J"
var key_4_config: String = "K"

func _ready():
	if FileAccess.file_exists("./settings.json"):
		var file = FileAccess.open("./settings.json", FileAccess.READ)
		var data = file.get_as_text()
		file.close()
		
		var settings: Dictionary = JSON.parse_string(data)
		fall_speed = settings["FallSpeed"]
		master_volume = settings["MasterVolume"]
		bgm_volume = settings["BGMVolume"]
		sfx_volume = settings["SFXVolume"]
		judge_offset = settings["JudgeOffset"]
		
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), linear_to_db(bgm_volume))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_volume))
		
		key_1_config = settings["Key1"]
		key_2_config = settings["Key2"]
		key_3_config = settings["Key3"]
		key_4_config = settings["Key4"]
		
		set_key_config("Key_1", key_1_config)
		set_key_config("Key_2", key_2_config)
		set_key_config("Key_3", key_3_config)
		set_key_config("Key_4", key_4_config)
		
	else :
		update_setting()

func update_setting():
	var settings: Dictionary = {
		"FallSpeed": fall_speed, 
		"MasterVolume": master_volume, 
		"BGMVolume": bgm_volume, 
		"SFXVolume": sfx_volume, 
		"JudgeOffset": judge_offset,
		"Key1": get_key_name("Key_1"),
		"Key2": get_key_name("Key_2"),
		"Key3": get_key_name("Key_3"),
		"Key4": get_key_name("Key_4") }
	
	var file = FileAccess.open("./settings.json", FileAccess.WRITE)
	var data = JSON.stringify(settings, "\t")
	file.store_string(data)
	file.close()

func reset_setting():
	set_key_config("Key_1", "D")
	set_key_config("Key_2", "F")
	set_key_config("Key_3", "J")
	set_key_config("Key_4", "K")
	
	update_setting()

func get_key_name(action_name: StringName):
	for event in InputMap.action_get_events(action_name):
		if event is InputEventKey:
			return event.as_text_physical_keycode()

func set_key_config(action_name: StringName, key_name: String):
	InputMap.action_erase_events(action_name)
	var new_key = InputEventKey.new()
	new_key.physical_keycode = OS.find_keycode_from_string(key_name)
	InputMap.action_add_event(action_name, new_key)
