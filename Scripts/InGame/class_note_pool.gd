extends Node
class_name NoteObjectPool

@export var tap_note_scene: PackedScene = preload("res://Scenes/tap_note.tscn")
@export var hold_note_scene: PackedScene = preload("res://Scenes/hold_note.tscn")

@export var game_manager: GameManager

enum NoteType {TAP, HOLD}

var recycle_tap_notes: Array[TapNote]
var recycle_hold_notes: Array[HoldNote]

func _ready() -> void:
	game_manager.end_game.connect(_on_end_game)
	init_pool_notes()

func init_pool_notes():
	var note_count: int = 20
	for i in note_count:
		var tap_note_obj: TapNote = tap_note_scene.instantiate()
		var hold_note_obj: HoldNote = hold_note_scene.instantiate()
		recycle_tap_notes.append(tap_note_obj)
		recycle_hold_notes.append(hold_note_obj)

func recycle_note(note_type: NoteType, note_obj):
	if note_type == NoteType.TAP:
		note_obj = note_obj as TapNote
		note_obj.reset_all_variables()
		note_obj.reset_times()
		recycle_tap_notes.append(note_obj)
	
	elif note_type == NoteType.HOLD:
		note_obj = note_obj as HoldNote
		note_obj.reset_all_variables()
		note_obj.reset_times()
		recycle_hold_notes.append(note_obj)

func return_note(note_type: NoteType):
	if note_type == NoteType.TAP:
		if not recycle_tap_notes.is_empty():
			var note_obj: TapNote = recycle_tap_notes.pop_back()
			return note_obj
		else :
			return tap_note_scene.instantiate()
	
	elif note_type == NoteType.HOLD:
		if not recycle_hold_notes.is_empty():
			var note_obj: HoldNote = recycle_hold_notes.pop_back()
			return note_obj
		else :
			return hold_note_scene.instantiate()

func _on_end_game():
	for note in recycle_hold_notes:
		note.queue_free()
	
	for note in recycle_tap_notes:
		note.queue_free()
	
	recycle_hold_notes.clear()
	recycle_tap_notes.clear()
