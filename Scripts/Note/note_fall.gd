extends Node2D

var speed: int = GlobalSettings.fall_speed * 50
@export var note_texture: ColorRect

var origin_length: int = 50

func _ready():
	origin_length = note_texture.size.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.y += delta * speed
	if position.y > 720 + speed * 0.2:
		queue_free()
