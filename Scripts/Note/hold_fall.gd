extends Node2D

@export var hold_texture: ColorRect
var speed: int = GlobalSettings.fall_speed * 50

var origin_length: int = 50
var length: float = 50
var duration: int

func _ready():
	origin_length = hold_texture.size.y
	hold_texture.size.y = length

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.y += delta * speed
	if position.y > 720 + hold_texture.size.y:
		queue_free()
