extends Node

@export var music: AudioStreamPlayer
@export var end_timer: Timer

var tween: Tween

func music_fade_out():
	tween = create_tween()
	tween.tween_property(music, "volume_db", -40, 10)

func _on_note_spawner_is_end_play():
	end_timer.start()

func _on_end_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")
