extends Node

@export var bpm: float
@export var bpm_timer: Timer
@export var offset: float
@export var bgm_offset: float
@export var beat_offset: float

var per_beat_second: float

# Called when the node enters the scene tree for the first time.
func _ready():
	per_beat_second = 60 / bpm
	bpm_timer.wait_time = per_beat_second
