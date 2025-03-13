extends Node

## 1 拍长度为 60 / BPM，转化为 ms 需要乘以 1000
@export var BPM: int = 120
var beat: int = 4

## 歌曲起始位置 (单位为 ms)
@export var music_start_position: int = 0

## TODO 使用 Array 储存变拍信息 (WIP, 暂用const)
const beat_group: Array = [
	[0, 4]
]

## TODO 使用 Array 储存BPM信息 (WIP, 暂用 const)
const BPM_group: Array = [
	[0, 120]
]

## 使用 Array 储存转化后的信息
## 格式为[ {"time": int, "track": Array, "length": Array }, ... ]( length只在hold生效 )
var note_array: Array = []
var hold_array: Array = []

## 使用 Dictionary 储存源note信息, [ x, [y] ]中 x 为时间(单位为 ms)， [y] 为轨道
## 使用 Dictionary 储存源hold信息, [ x, [ [y], [z] ]中 x 为时间， [y] 为轨道, [z] 为 hold 对应轨道时间长度
## 在chartinfo中不储存源数据，只给出示例
const example_note_group: Dictionary = {
	0: [1], 435: [1, 2],
	870: [1], 1304: [1, 2],
	1739:[1], 2174: [1, 2],
}

const example_hold_group: Dictionary = {
	0: [ [1, 2], [217, 217] ],
}

## 在源数据中分离 note 出现时间
func split_note_times(array: Array):
	var note_times: Array = []
	for note in array:
		note_times.append(note["time"])
	return note_times

## 在源数据中分离 note 对应轨道
func split_note_tracks(array: Array):
	var note_tracks: Array = []
	for note in array:
		note_tracks.append(note["track"])
	return note_tracks

## 在源数据中分离 hold 音符长度
func split_hold_lengths(array: Array):
	var hold_lengths: Array = []
	for hold in array:
		hold_lengths.append(hold["length"])
	return hold_lengths

## 计算这个关卡的音符个数
func calculate_note_count():
	var note_total: int
	var detect_notes: int
	var note_tracks: Array = split_note_tracks(note_array)
	var hold_tracks: Array = split_note_tracks(hold_array)
	for arr in note_tracks:
		note_total += arr.size()
	for arr: Array in hold_tracks:
		for i in arr:
			if i == 5:
				detect_notes += 1
			note_total += 2
	return note_total - (detect_notes * 2)
