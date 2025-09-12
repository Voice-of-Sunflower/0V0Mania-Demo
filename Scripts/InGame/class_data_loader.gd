extends Node
class_name PlaySceneDataLoader

signal reload_data(what_data: DataType)
signal loading_finished()

enum DataType {BEATMAP, AUDIO}

@export_global_file("*.osu") var osu_file_path: String = ""
@export_global_file("*.wav", "*.mp3", "*.ogg") var audio_file_path: String = ""
@export var beatmap_info: BeatmapInfo 

@export var track_manager: TrackManager
@export var judge_manager: JudgeManager
@export var audio_manager: AudioManager
@export var score_manager: ScoreManager

func _ready() -> void:
	if not osu_file_path.is_empty():
		_on_reload_data(DataType.BEATMAP)
	
	if not audio_file_path.is_empty():
		_on_reload_data(DataType.AUDIO)

func _on_reload_data(what_data: DataType):
	var thread: Thread = Thread.new()
	
	match what_data:
		DataType.BEATMAP:
			thread.start(parse_osu_file.bind(osu_file_path))
			var result = thread.wait_to_finish()
			if result:
				_load_data(result)
				loading_finished.emit()
		DataType.AUDIO:
			thread.start(parse_audio_file.bind(audio_file_path))
			var audio_stream = thread.wait_to_finish()
			if audio_stream:
				_load_audio(audio_stream)
				loading_finished.emit()

func parse_osu_file(path: String) -> BeatmapInfo:
	var parser: OSUManiaParser = OSUManiaParser.new()
	if parser.parse_file(path):
		var parser_data := parser.get_results()
		 
		var beatmap_info: BeatmapInfo = BeatmapInfo.new()
		beatmap_info.tap_time = parser_data["notes"]
		beatmap_info.hold_time = parser_data["long_notes"]
		
		return beatmap_info
	
	return null

func parse_audio_file(path: String):
	match path.get_extension():
		"mp3":
			return AudioStreamMP3.load_from_file(path)
		"ogg":
			return AudioStreamOggVorbis.load_from_file(path)
		"wav":
			return AudioStreamWAV.load_from_file(path)
		_:
			push_error("非音频文件")
			return null

func _load_data(beatmap_info: BeatmapInfo):
	self.beatmap_info = beatmap_info
	
	track_manager.note_data = beatmap_info
	judge_manager.beatmap_file = beatmap_info
	score_manager.beatmap_file = beatmap_info

func _load_audio(audio_stream):
	audio_manager.set_audio_stream(audio_stream)

func _on_file_dialog_file_selected(path: String) -> void:
	var audio_format: PackedStringArray = ["mp3", "ogg", "wav"]
	if path.get_extension() in audio_format:
		audio_file_path = path
		reload_data.emit(DataType.AUDIO)
	
	if path.get_extension() == "osu":
		osu_file_path = path
		reload_data.emit(DataType.BEATMAP)

func _on_game_manager_reset_all() -> void:
	beatmap_info = null
	
	audio_manager.clear_audio_stream()
	track_manager.note_data = null
	judge_manager.beatmap_file = null
	score_manager.beatmap_file = null
