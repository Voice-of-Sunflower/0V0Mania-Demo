extends Node
class_name JudgeManager

## 为了方便补全，使用RatingTap枚举传递rating变量，实际上任意int值都可以传递
signal update_judge_rating(rating: RatingTap)

@export var audio_manager: AudioManager
@export var score_manager: ScoreManager

@export var beatmap_file: BeatmapInfo

var music_offset: float

#region Tap音符的判定区间(单位为ms)，非自定义情况下为常量，名称使用全体大写
var MARVELOUS_TAP: int = 25
var PERFECT_TAP: int = 40
var GREAT_TAP: int = 75
var GOOD_TAP: int = 100
var MISS_TAP: int = 999
#endregion

#region Hold音符的判定区间(单位为ms)，非自定义情况下为常量，名称使用全体大写
var MARVELOUS_HOLD: int = 35
var PERFECT_HOLD: int = 50
var GREAT_HOLD: int = 90
var GOOD_HOLD: int = 120
var MISS_HOLD: int = 999
#endregion

enum RatingTap {MARVELOUS = 25, PERFECT = 40, GREAT = 75, GOOD = 100, MISS = 150}
enum RatingTapHold {MARVELOUS = 35, PERFECT = 50, GREAT = 90, GOOD = 120, MISS = 150}

func _ready() -> void:
	await get_tree().process_frame
	
	if beatmap_file:
		music_offset = beatmap_file.offset

func get_rating(hit_offset: int):
	audio_manager.play_hit_sound()
	
	var judge_rating: RatingTap
	hit_offset += GlobalSettings.judge_offset
	
	if hit_offset <= MARVELOUS_TAP:
		update_judge_rating.emit(RatingTap.MARVELOUS)
	
	elif hit_offset <= PERFECT_TAP:
		update_judge_rating.emit(RatingTap.PERFECT)
	
	elif hit_offset <= GREAT_TAP:
		update_judge_rating.emit(RatingTap.GREAT)
	
	elif hit_offset <= GOOD_TAP:
		update_judge_rating.emit(RatingTap.GOOD)
	
	else :
		update_judge_rating.emit(RatingTap.MISS)

func get_rating_hold(hit_offset: int):
	audio_manager.play_hit_sound()
	
	var judge_rating: RatingTap
	hit_offset += GlobalSettings.judge_offset
	
	if hit_offset <= MARVELOUS_HOLD:
		update_judge_rating.emit(RatingTap.MARVELOUS)
	
	elif hit_offset <= PERFECT_HOLD:
		update_judge_rating.emit(RatingTap.PERFECT)
	
	elif hit_offset <= GREAT_HOLD:
		update_judge_rating.emit(RatingTap.GREAT)
	
	elif hit_offset <= GOOD_HOLD:
		update_judge_rating.emit(RatingTap.GOOD)
	
	else :
		update_judge_rating.emit(RatingTap.MISS)
