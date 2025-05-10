extends Node

@export var info_container: VBoxContainer

func _ready():
	GlobalVariable.button_visible_change.connect(_on_change_button_visible)

func _on_change_button_visible():
	info_container.visible = true
