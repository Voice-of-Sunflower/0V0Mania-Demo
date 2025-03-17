extends Node

var tracks: int
var current_note_index: int

var current_track_note_index: Array[int] = [0, 0, 0, 0]

signal reset_index()

func _ready() -> void:
	reset_index.connect(_on_index_reset)

func _on_index_reset():
	current_track_note_index = [0, 0, 0, 0]
