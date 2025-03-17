extends Node

@export var music: AudioStreamPlayer
@export var end_timer: Timer

var tween: Tween

func _on_note_spawner_is_end_play():
	end_timer.start()

## 跳转分数结算场景
func _on_end_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")
