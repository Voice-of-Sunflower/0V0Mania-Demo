extends Node

@export var no_beatmap_hint: Label
@export var music_info_item: PackedScene
@export var list_node: VBoxContainer

var beatmaps_path: String = "./Beatmaps/"

func _ready():
	GlobalVariable.selected_beatmap = null
	if !DirAccess.dir_exists_absolute(beatmaps_path):
		DirAccess.make_dir_absolute(beatmaps_path)
	
	reload_beatmap_list()
	GlobalVariable.load_beatmaps.connect(_on_load_beatmap_list)

func _on_load_beatmap_list():
	reload_beatmap_list()

func add_music_item(path: String):
	var music_item_obj: Button = music_info_item.instantiate()
	music_item_obj.beatmap_path = path
	list_node.add_child(music_item_obj)

func load_beatmap_list():
	var directories = DirAccess.open(beatmaps_path).get_directories()
	
	if directories.is_empty():
		no_beatmap_hint.visible = true
	else :
		no_beatmap_hint.visible = false
	
	for directory in directories:
		var path = beatmaps_path.path_join(directory)
		if FileAccess.file_exists(path.path_join("beatmap_info.json")):
			add_music_item(path)

func reload_beatmap_list():
	for child in list_node.get_children():
		if child.name == "NoBeatmapHint":
			continue
		child.queue_free()
	
	load_beatmap_list()
