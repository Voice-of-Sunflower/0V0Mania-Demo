extends Node2D

@export var note_texture: ColorRect
@export var hit_judge_script: Note

var index: int
var speed: int = GlobalSettings.fall_speed * 50
var origin_length: int = 50

func _ready():
	origin_length = note_texture.size.y
	hit_judge_script.current_note_index = index

func _physics_process(delta):
	position.y += delta * speed
	if position.y > 720 + speed * 0.2:
		queue_free()
