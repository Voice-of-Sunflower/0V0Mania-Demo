extends Node

func file_load(beatmap_path: String):
	## 读取mp3音频文件赋值到全局变量中
	if FileAccess.file_exists(beatmap_path.path_join("music.mp3")):
		var audio_file_data = FileAccess.get_file_as_bytes(beatmap_path.path_join("music.mp3"))
		var audio_stream: AudioStream = AudioStreamMP3.load_from_buffer(audio_file_data)
		audio_stream.loop = false
		GlobalVariable.selected_beatmap_music = audio_stream
	
	## 读取ogg音频文件赋值到全局变量中
	elif FileAccess.file_exists(beatmap_path.path_join("music.ogg")):
		var audio_file_data = FileAccess.get_file_as_bytes(beatmap_path.path_join("music.ogg"))
		var audio_stream: AudioStream = AudioStreamOggVorbis.load_from_buffer(audio_file_data)
		audio_stream.loop = false
		GlobalVariable.selected_beatmap_music = audio_stream
	
	## 读取失败就赋值null
	else :
		GlobalVariable.selected_beatmap_music = null
