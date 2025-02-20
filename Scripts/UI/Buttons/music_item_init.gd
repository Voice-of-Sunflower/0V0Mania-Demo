extends Button

var beatmap_path: String
var beatmap_info : Dictionary
var artwork_image: Image

@export var music_title: Label
@export var level_title: Label
@export var image_rect: TextureRect
@export var play_button: Button

var music_title_text: String = "{0} - {1}"

var is_artwork_exist: bool = true

signal loading_finished

func _ready():
	load_info()
	
func load_info():
	var file = FileAccess.open(beatmap_path.path_join("beatmap_info.json"), FileAccess.READ)
	var data = file.get_as_text()
	file.close()
	
	beatmap_info = JSON.parse_string(data)
	loading_finished.emit()
	music_title.text = music_title_text.format({"0": beatmap_info["Author"], "1": beatmap_info["Name"]})
	
	if FileAccess.open(beatmap_path.path_join("cover.jpg"), FileAccess.READ):
		set_image(beatmap_path.path_join("cover.jpg"))
	elif FileAccess.open(beatmap_path.path_join("cover.png"), FileAccess.READ):
		set_image(beatmap_path.path_join("cover.png"))
	else :
		is_artwork_exist = false
		artwork_image = load("res://Pictures/audio_file_music_icon.png")

func set_image(image_path: String):
	var image_texture = ImageTexture.new()
	artwork_image = Image.load_from_file(image_path)
	
	image_texture.set_image(artwork_image)
	image_rect.texture = image_texture

func set_play_button_visible():
	play_button.visible = true

func set_play_button_invisible():
	play_button.visible = false
