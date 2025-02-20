extends Node

@export var music_title: Label
@export var level_name: Label

@export var perfect_count: Label
@export var great_count: Label
@export var good_count: Label
@export var miss_count: Label

@export var image: TextureRect

@export var score: Label
@export var max_count: Label
@export var rating: Label

const music_title_text: String = "{0} - {1}"
const score_text: String = "Score : {0}"
const max_combo_text: String = "Max Combo : {0}x"
const perfect_count_text: String = "PERFECT : {0}({1})"
const great_count_text: String = "GREAT: {0}"
const good_count_text: String = "GOOD: {0}"
const miss_count_text: String = "MISS: {0}"

var beatmap_info: Dictionary
var ingame_score: int

func _ready():
	beatmap_info = GlobalVariable.selected_beatmap_info
	music_title.text = music_title_text.format({"0": beatmap_info["Author"], "1": beatmap_info["Name"]})
	ingame_score = GlobalScore.in_game_score
	level_name.text = GlobalVariable.selected_level_name

	var image_texture = ImageTexture.new()
	image_texture.set_image(GlobalVariable.beatmap_artwork)
	image.texture = image_texture
	
	var fixed_score = "%07d" % ingame_score
	score.text = score_text.format({"0": fixed_score})
	max_count.text = max_combo_text.format({"0": GlobalScore.max_combo})
	perfect_count.text = perfect_count_text.format({"0": GlobalScore.rate_count["PERFECT"], "1": GlobalScore.rate_count["MARVELOUS"]})
	great_count.text = great_count_text.format({"0": GlobalScore.rate_count["GREAT"]})
	good_count.text = good_count_text.format({"0": GlobalScore.rate_count["GOOD"]})
	miss_count.text = miss_count_text.format({"0": GlobalScore.rate_count["MISS"]})
	
	rating_judge(GlobalScore.in_game_score)

func rating_judge(score: int):
	if score == 1005000:
		rating.text = "MAX+"
		rating.label_settings = ResourceLoader.load("res://LabelSettings/max_label.tres")
	elif score >= 1000000:
		rating.text = "MAX"
		rating.label_settings = ResourceLoader.load("res://LabelSettings/max_label.tres")
	elif score >= 995000:
		rating.text = "SS+"
		rating.label_settings = ResourceLoader.load("res://LabelSettings/perfect_label.tres")
	elif score >= 990000:
		rating.text = "SS"
		rating.label_settings = ResourceLoader.load("res://LabelSettings/perfect_label.tres")
	elif score >= 980000:
		rating.text = "S+"
		rating.label_settings = ResourceLoader.load("res://LabelSettings/perfect_label.tres")
	elif score >= 970000:
		rating.text = "S"
		rating.label_settings = ResourceLoader.load("res://LabelSettings/perfect_label.tres")
	elif score >= 950000:
		rating.text = "A+"
		rating.label_settings = ResourceLoader.load("res://LabelSettings/great_label.tres")
	elif score >= 920000:
		rating.text = "A"
		rating.label_settings = ResourceLoader.load("res://LabelSettings/great_label.tres")
	elif score >= 870000:
		rating.text = "B+"
		rating.label_settings = ResourceLoader.load("res://LabelSettings/good_label.tres")
	elif score >= 820000:
		rating.text = "B"
		rating.label_settings = ResourceLoader.load("res://LabelSettings/good_label.tres")
	else :
		rating.text = "C"
		rating.label_settings = ResourceLoader.load("res://LabelSettings/bad_label.tres")
