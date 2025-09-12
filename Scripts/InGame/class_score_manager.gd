extends Node
class_name ScoreManager

signal update_scores()

@export var beatmap_file: BeatmapInfo

var marvelous_count: int
var perfect_count: int
var great_count: int
var good_count: int
var miss_count: int

var max_combo: int
var combo_count: int
var hit_note_total: int

var accuracy: float

func _ready() -> void:
	await get_tree().process_frame
	
	if beatmap_file:
		hit_note_total = beatmap_file.get_note_count()

func _add_count_by_rating(rating: JudgeManager.RatingTap):
	max_combo = maxi(combo_count, max_combo)
	combo_count += 1
	match rating:
		JudgeManager.RatingTap.MARVELOUS:
			marvelous_count += 1
		JudgeManager.RatingTap.PERFECT:
			perfect_count += 1
		JudgeManager.RatingTap.GREAT:
			great_count += 1
		JudgeManager.RatingTap.GOOD:
			good_count += 1
		JudgeManager.RatingTap.MISS:
			miss_count += 1
			combo_count = 0
	
	_calculate_accuracy()
	update_scores.emit()

func _calculate_accuracy():
	var marvelous_score: float = float(marvelous_count) / hit_note_total * 1.01
	var perfect_score: float = float(perfect_count) / hit_note_total
	var great_score: float = float(great_count) / hit_note_total * 0.75
	var good_score: float = float(good_count) / hit_note_total * 0.5
	accuracy = (marvelous_score + perfect_score + great_score + good_score) * 100

func _on_judge_manager_update_judge_rating(rating: JudgeManager.RatingTap) -> void:
	_add_count_by_rating(rating)

func _on_data_loader_loading_finished() -> void:
	hit_note_total = beatmap_file.get_note_count()
