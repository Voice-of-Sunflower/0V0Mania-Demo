extends Node

@export var edit_info_button: Button
@export var delete_beatmap_button: Button
@export var add_level_button: Button

@export var image_container: MarginContainer
@export var info_container: VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVariable.button_visible_change.connect(_on_change_button_visible)

func _on_change_button_visible():
	edit_info_button.visible = true
	delete_beatmap_button.visible = true
	add_level_button.visible = true
	image_container.visible = true
	info_container.visible = true
