extends Node

@export var filedialog: FileDialog

var get_files: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_chart_files():
	pass

func _on_file_dialog_dir_selected(dir: String):
	var required_files: Array = ["chart_note.json", "chart_hold.json", "music.mp3", "chart_info.json"]
	var optional_files: Array = ["chart.mid"]
	var missing_files: Array = []
	
	for file_name in required_files:
		var file_path = dir.path_join(file_name)
		if FileAccess.file_exists(file_path):
			get_files.append(file_path)
		else :
			missing_files.append(file_name)
		
	
	if missing_files.has("chart_note.json") || missing_files.has("chart_hold.json"):
		var file_path = dir.path_join(optional_files[0])
		if FileAccess.file_exists(file_path):
			missing_files.erase("chart_note.json")
			missing_files.erase("chart_hold.json")
			get_files.append(file_path)
		else:
			missing_files.append(optional_files[0])
	
	if missing_files.size() == 0:
		print("Successful!")
	if missing_files.has("chart.mid"):
		print("Missing chart file, please put the chart_note.json and chart_hold.json into folder(The chart.mid is also ok)")
	if missing_files.has("music.mp3"):
		print("Missing music file, please put the music.mp3 into folder")
	if missing_files.has("chart_info.json"):
		print("Missing chart info file, please regenerate the chart_info.json")

func _on_load_chart_button_pressed():
	filedialog.popup_centered()
