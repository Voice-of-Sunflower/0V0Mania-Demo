extends Node

@export_range(1.0, 100.0, 0.1) var fall_speed: float = 30.0
@export var judge_offset: int = 0

@export_range(0.0, 100.0) var master_volume: float = 12.0
@export_range(0.0, 100.0) var music_volume: float = 80.0
@export_range(0.0, 100.0) var sfx_volume: float = 80.0

@export_enum("en_US", "zh_CN") var language: String = "en_US"

@export var v_sync_mode: GlobalSettings.VSyncMode = GlobalSettings.VSyncMode.MAILBOX
@export_range(30.0, 1000.0) var max_fps: int = 1000

func _ready() -> void:
	_update_settings()
	GlobalSettings.save_config_file()
	GlobalSettings.load_config_file()

func _update_settings():
	GlobalSettings.fall_speed = fall_speed
	GlobalSettings.judge_offset = judge_offset
	
	GlobalSettings.master_volume = master_volume / 100.0
	GlobalSettings.bgm_volume = music_volume / 100.0
	GlobalSettings.sfx_volume = sfx_volume / 100.0
	
	GlobalSettings.language = language
	
	GlobalSettings.v_sync_mode = v_sync_mode
	GlobalSettings.max_fps = max_fps
