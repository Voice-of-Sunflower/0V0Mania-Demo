extends Node

# 游戏
var fall_speed: float = 30.0
var judge_offset: int = 0

# 音量
var master_volume: float = 0.12
var bgm_volume: float = 0.8
var sfx_volume: float = 0.8

# 性能
enum VSyncMode {ENABLED, MAILBOX, DISABLED}
var v_sync_mode: VSyncMode = VSyncMode.MAILBOX
var max_fps: int = 1000

# 语言
var language: String = "en_US"

func save_config_file():
	var config_file: ConfigFile = ConfigFile.new()
	
	config_file.set_value("GAME", "FallSpeed", fall_speed)
	config_file.set_value("GAME", "JudgeOffset", judge_offset)
	
	config_file.set_value("VOLUME", "MasterVolume", master_volume)
	config_file.set_value("VOLUME", "BGMVolume", bgm_volume)
	config_file.set_value("VOLUME", "SFXVloume", sfx_volume)
	
	config_file.set_value("PERFORMANCE", "VSyncMode", v_sync_mode)
	config_file.set_value("PERFORMANCE", "MaxFps", max_fps)
	
	config_file.set_value("LOCALIZE", "Language", language)
	
	config_file.save("./settings.cfg")

func load_config_file():
	var config_file: ConfigFile = ConfigFile.new()
	var error: = config_file.load("./settings.cfg")
	if error != OK:
		save_config_file()
	
	# 获取变量
	master_volume = config_file.get_value("VOLUME", "MasterVolume", master_volume)
	bgm_volume = config_file.get_value("VOLUME", "BGMVolume", bgm_volume)
	sfx_volume = config_file.get_value("VOLUME", "SFXVloume", sfx_volume)
	
	fall_speed = config_file.get_value("GAME", "FallSpeed", fall_speed)
	judge_offset = config_file.get_value("GAME", "JudgeOffset", judge_offset)
	
	v_sync_mode = config_file.get_value("PERFORMANCE", "VSyncMode", v_sync_mode)
	match v_sync_mode:
		VSyncMode.DISABLED:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		VSyncMode.ENABLED:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		VSyncMode.MAILBOX:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_MAILBOX)
	
	max_fps = config_file.get_value("PERFORMANCE", "MaxFps", max_fps)
	if max_fps >= 1000:
		Engine.max_fps = 0
	else :
		Engine.max_fps = max_fps
	
	language = config_file.get_value("LOCALIZE", "Language", language)
	
	# 修改参数
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), linear_to_db(bgm_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_volume))
	
	TranslationServer.set_locale(language)

## 自动本地化设置
func set_localize() -> String:
	var language = "automatic"
	if language == "automatic":
		var preferred_language = OS.get_locale_language()
		TranslationServer.set_locale(preferred_language)
		return preferred_language
	else:
		TranslationServer.set_locale("en")
		return "en"
