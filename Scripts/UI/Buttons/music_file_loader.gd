extends Node

func file_load(beatmap_path: String):
	## 读取音频文件赋值到全局变量中
	if FileAccess.file_exists(beatmap_path.path_join("music.mp3")):
		var audio_file_data = FileAccess.get_file_as_bytes(beatmap_path.path_join("music.mp3"))
		var audio_stream: AudioStream = AudioStreamMP3.new()
		audio_stream.loop = false
		audio_stream.data = audio_file_data
		GlobalVariable.selected_beatmap_music = audio_stream
	else :
		GlobalVariable.selected_beatmap_music = null
