extends Button

var beatmap_path: String
var beatmap_info : Dictionary
var cover_image: Image

@export var music_title: Label
@export var level_title: Label
@export var image_rect: TextureRect
@export var play_button: Button

var music_title_text: String = "{0} - {1}"

var is_cover_exist: bool = true

signal loading_finished

func _ready():
	load_info()

func load_info():
	## 获取谱面信息
	var file = FileAccess.open(beatmap_path.path_join("beatmap_info.json"), FileAccess.READ)
	var data = file.get_as_text()
	file.close()
	beatmap_info = JSON.parse_string(data)
	
	loading_finished.emit()
	
	## 设置谱面标题
	music_title.text = music_title_text.format({"0": beatmap_info["Author"], "1": beatmap_info["Name"]})
	
	## 获取歌曲封面
	if FileAccess.open(beatmap_path.path_join("cover.jpg"), FileAccess.READ):
		set_image(beatmap_path.path_join("cover.jpg"))
	elif FileAccess.open(beatmap_path.path_join("cover.png"), FileAccess.READ):
		set_image(beatmap_path.path_join("cover.png"))
	else :
		is_cover_exist = false
		cover_image = load("res://Pictures/audio_file_music_icon.png")

## 设置谱面封面
func set_image(image_path: String):
	var image_texture = ImageTexture.new()
	cover_image = Image.load_from_file(image_path)
	
	if cover_image == null:
		cover_image = load("res://Pictures/audio_file_music_icon.png")
	image_texture.set_image(cover_image)
	image_rect.texture = image_texture

## 设置play按钮显示
func set_play_button_visible():
	play_button.visible = true

## 设置play按钮隐藏
func set_play_button_invisible():
	play_button.visible = false
