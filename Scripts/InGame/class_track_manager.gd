extends Node
class_name TrackManager

signal play_completed()
signal start_generate()

## Note 相关
@export var note_data: BeatmapInfo

## Track 相关
@export_category("TrackNodes")
@export var track_parent_node: Control
@export var track1: NoteTrack
@export var track2: NoteTrack
@export var track3: NoteTrack
@export var track4: NoteTrack

@export_category("Managers")
@export var audio_manager: AudioManager
@export var time_manager: GameTime
@export var game_manager: GameManager
@export var judge_manager: JudgeManager

var completed_track_count: int = 0
var auto_play_mode: bool = false

func _ready() -> void:
	play_completed.connect(_on_play_completed)

func _load_note_data():
	var tap_note_dictionary: Dictionary = note_data.tap_time
	var hold_note_dictionary: Dictionary = note_data.hold_time
	var time_difference: float = time_manager.time_difference
	
	var index: int = 1
	
	for node: NoteTrack in track_parent_node.get_children():
		var time_array: PackedInt32Array
		node.time_difference = time_difference
		
		if tap_note_dictionary.has(index):
			node.tap_time = tap_note_dictionary[index]
		
		if hold_note_dictionary.has(index):
			node.hold_time = hold_note_dictionary[index]
		
		node.note_count = node.tap_time.size() + node.hold_time.size()
		
		index += 1

func _on_play_completed():
	completed_track_count += 1
	if completed_track_count == track_parent_node.get_child_count():
		game_manager.end_game.emit()

func _on_data_loader_loading_finished() -> void:
	await get_tree().process_frame
	_load_note_data()
