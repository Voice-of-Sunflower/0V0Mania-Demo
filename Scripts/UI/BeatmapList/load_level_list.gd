extends Node

@export var level_container: GridContainer
@export var level_button: PackedScene

var beatmap_path: String

func _ready():
	GlobalVariable.load_levels.connect(_on_load_level_list)

func _on_load_level_list():
	beatmap_path = GlobalVariable.selected_beatmap_path
	reload_level_list()

func load_level_directories():
	var level_directories = DirAccess.open(beatmap_path).get_directories()
	
	if level_directories.is_empty():
		return
	else:
		for directory in level_directories:
			var path = beatmap_path.path_join(directory)
			
			var is_beatmap_note_exist = FileAccess.file_exists(path.path_join("beatmap_note.json"))
			var is_beatmap_hold_exist = FileAccess.file_exists(path.path_join("beatmap_hold.json"))
			
			if is_beatmap_note_exist && is_beatmap_hold_exist:
				add_level_button_item(directory)

func add_level_button_item(text: String):
	var level_button_obj: Button = level_button.instantiate()
	level_button_obj.text = text
	level_container.add_child(level_button_obj)

func reload_level_list():
	for child in level_container.get_children():
		if child.name == "AddLevelButton":
			continue
		child.queue_free()
	
	load_level_directories()
