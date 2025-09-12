extends Node
class_name GameManager

signal start_game()
signal pause_game()
signal continue_game()
signal end_game()
signal reset_all()

enum GameState {IDLE, RUNNING, PAUSE}
var current_game_state: GameState = GameState.IDLE

@export var ui_manager: InGameUI
@export var time_manager: GameTime
@export var audio_manager: AudioManager

func _ready() -> void:
	start_game.connect(_start_game)
	pause_game.connect(_pause_game)
	continue_game.connect(_continue_game)
	end_game.connect(_end_game)

## 开始游戏
func _start_game():
	current_game_state = GameState.RUNNING

## 结束一局游戏
func _end_game():
	current_game_state = GameState.IDLE

## 暂停游戏
func _pause_game():
	current_game_state = GameState.PAUSE
	get_tree().paused = true

## 继续游戏
func _continue_game():
	get_tree().paused = false
