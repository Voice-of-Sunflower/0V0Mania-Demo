extends Node

var selected_beatmap_path: String
var selected_beatmap_info: Dictionary
var selected_level_path: String
var selected_level_name: String
var selected_beatmap_music: AudioStream
var selected_beatmap: Button

var auto_play_mode: bool = false

var beatmap_cover: Image

var hit_sound: AudioStreamPlayer

signal card_info_change(is_artwork_exist: bool)
signal button_visible_change()
signal load_levels()
signal load_beatmaps()
signal level_name_change(level_name: String)
signal preview_music()
signal enter_beatmap_play_scene()
signal continue_play(pause_duration: int)

func _ready():
	enter_beatmap_play_scene.connect(_on_enter_beatmap_play_scene)

func _on_enter_beatmap_play_scene():
	hit_sound = get_tree().get_first_node_in_group("hit_sound")
