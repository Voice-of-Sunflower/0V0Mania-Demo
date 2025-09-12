extends RefCounted

## 包装一些常用方法的类
class_name Utility

## 过滤并去除文件夹不能包含的符号
static func filter_invalid_symbol(string_name: String):
	if string_name.begins_with(" "):
		string_name.trim_prefix(" ")
	if string_name.ends_with(" "):
		string_name.trim_suffix(" ")

	var invalid_chars = ["<", ">", ":", "\"", "/", "\\", "|", "?", "*", "."]
	for char in invalid_chars:
		string_name = string_name.replace(char, "")
	return string_name

## 解压zip类文件(带有格式过滤器的版本)
static func zip_unzipper_with_ext(file_path: String, target_path: String, ext_filter: PackedStringArray):
	var zip_reader = ZIPReader.new()
	if zip_reader.open(file_path) == 0:
		for file_name in zip_reader.get_files():
			var file_ext: String = file_name.get_extension()
			if file_ext in ext_filter:
				var target_file_path: String = target_path.path_join(file_name)
				var file = FileAccess.open(target_file_path, FileAccess.WRITE)
				var buffer = zip_reader.read_file(file_name)
				file.store_buffer(buffer)
				file.close()
