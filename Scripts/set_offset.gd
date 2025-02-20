extends Node

@export var offset_text: Label
@export var offset_edit: TextEdit
@export var base_attribute: Node
@export var bgm_offset_timer: Timer
@export var bgm: AudioStreamPlayer

var origin_text = "Now Offset: {offset}"

signal setting_offset

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_offset_text()
	bgm_offset_timer.wait_time = base_attribute.bgm_offset / 1000

func _on_apply_button_pressed():
	if offset_edit.text != null:
		base_attribute.offset = float(offset_edit.text)
		reset_offset_text()
		setting_offset.emit()

func reset_offset_text():
	offset_text.text = origin_text.format({"offset": base_attribute.offset})

func _on_bgm_offset_timer_timeout():
	bgm.play()
