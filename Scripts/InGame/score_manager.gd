extends Node

@export var chart_info: Node

@export var perfect_text_label: Label
@export var great_text_label: Label
@export var good_text_label: Label
@export var miss_text_label: Label
@export var accuracy_text_label: Label

@export var rate_text_label: Label
@export var combo_text_label: Label
@export var score_text_label: Label

#const perfect_text = "PERFECT: {count}"
#const great_text = "GREAT: {count}"
#const good_text = "GOOD: {count}"
#const miss_text = "MISS: {count}"
#const acc_text = "ACC: {acc} %"

var hit_note_count: int = 0
var note_total: int
var marvelous_count: int = 0
var perfect_count: int = 0
var great_count: int = 0
var good_count: int = 0
var miss_count: int = 0

var combo: int = 0
var max_combo: int = 0
var score: int = 0
var fixed_score: String

var accuracy: float = 0
var fixed_acc: String

enum rate_offset { MARVELOUS = 35, PERFECT = 50, GREAT = 80, GOOD = 100, MISS = 120 }

func _ready():
	reset_all()

## 使用获取偏移值进行音符评级判定
func _on_note_judger_add_score(rate):
	## 匹配 note 评级
	match rate:
		rate_offset.MARVELOUS:
			marvelous_count += 1
			combo += 1
			rate_text_label.text = "PERFECT+"
			add_score()
		rate_offset.PERFECT:
			perfect_count += 1
			combo += 1
			rate_text_label.text = "PERFECT"
			add_score()
		rate_offset.GREAT:
			great_count += 1
			combo += 1
			rate_text_label.text = "GREAT"
			add_score()
		rate_offset.GOOD:
			good_count += 1
			combo += 1
			rate_text_label.text = "GOOD"
			add_score()
		rate_offset.MISS:
			miss_count += 1
			combo = 0
			rate_text_label.text = "MISS"
	
	## 刷新combo信息
	max_combo = max(combo, max_combo)
	combo_text_label.text = str(combo)

## 重置变量
func reset_all():
	perfect_count = 0
	great_count = 0
	good_count = 0
	miss_count = 0
	
	#perfect_text_label.text = perfect_text.format({"count": perfect_count})
	#great_text_label.text = great_text.format({"count": great_count})
	#good_text_label.text = good_text.format({"count": good_count})
	#miss_text_label.text = miss_text.format({"count": miss_count})
	#
	#accuracy = 0
	#fixed_acc = "%.2f" % accuracy
	#accuracy_text_label.text = acc_text.format({"acc": fixed_acc})

#func reset_accuracy():
	#accuracy = float(perfect_count * 100 + great_count * 75 + good_count * 50) / float(hit_note_count)
	#fixed_acc = "%.2f" % accuracy
	#accuracy_text_label.text = acc_text.format({"acc": fixed_acc})

## 增加分数并修改显示
func add_score():
	score = float(marvelous_count * 101 + perfect_count * 100 + great_count * 75 + good_count * 50) / float(note_total) * 10000
	fixed_score = "%07d" % (score + max_combo)
	score_text_label.text = fixed_score

func _on_chart_loader_loading_finish():
	note_total = chart_info.calculate_note_count()

func _on_end_timer_timeout():
	GlobalScore.in_game_score = score + max_combo
	GlobalScore.max_combo = max_combo
	GlobalScore.rate_count["MARVELOUS"] = marvelous_count
	GlobalScore.rate_count["PERFECT"] = perfect_count + marvelous_count
	GlobalScore.rate_count["GREAT"] = great_count
	GlobalScore.rate_count["GOOD"] = good_count
	GlobalScore.rate_count["MISS"] = miss_count
