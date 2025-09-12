extends Resource
class_name BeatmapInfo

enum NoteType {TAP, HOLD}

@export var level_name: StringName
@export var author: StringName
@export var level_rating: float
@export var BPM: PackedFloat32Array

@export_global_file("*.tres") var file_path: String

## tap_time结构： {track_index: [note_time1, note_time2, ...], ...}
@export var tap_time: Dictionary
## hold_time结构： {track_index: [ [note_time1_start, note_time1_end], [note_time2_start, note_time2_end], ...], ...}
@export var hold_time: Dictionary

func get_tap_count() -> int:
	var tap_note_count: int
	var tap_time_dict_keys = tap_time.keys()
	for key in tap_time_dict_keys:
		tap_note_count += tap_time[key].size()
	
	return tap_note_count

func get_hold_count() -> int:
	var hold_note_count: int
	var hold_time_dict_keys = hold_time.keys()
	for key in hold_time_dict_keys:
		hold_note_count += hold_time[key].size() * 2
	
	return hold_note_count

func get_note_count() -> int:
	var tap_note_count: int = get_tap_count()
	var hold_note_count: int = get_hold_count()
	return tap_note_count + hold_note_count
