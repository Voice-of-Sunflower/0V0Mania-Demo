extends Node
class_name InGameUI

const TAP_TEXT: String = "Tap: {0}"
const HOLD_TEXT: String = "Hold: {0}"
const TOTAL_TEXT: String = "Total: {0}"
const AUDIO_TIME_TEXT: String = "Length: %d : %02d"

const MARVELOUS_LABEL_TEXT: String = "MARVELOUS: {0}"
const PERFECT_LABEL_TEXT: String = "PERFECT: {0}"
const GREAT_LABEL_TEXT: String = "GREAT: {0}"
const GOOD_LABEL_TEXT: String = "GOOD: {0}"
const MISS_LABEL_TEXT: String = "MISS: {0}"
const ACCURACY_LABEL_TEXT: String = "ACC: %.2f %%"

const MARVELOUS_COLOR: Color = Color.FLORAL_WHITE
const PERFECT_COLOR: Color = Color.ORANGE
const GREAT_COLOR: Color = Color.GREEN_YELLOW
const GOOD_COLOR: Color = Color.LIME_GREEN
const MISS_COLOR: Color = Color.DIM_GRAY

#region DebugNode
@export_category("DebugInfo1")
@export var tap_count_label: Label
@export var hold_count_label: Label
@export var total_count_label: Label
@export var audio_length_label: Label

@export_category("DebugInfo2")
@export var marvelous_label: Label
@export var perferct_label: Label
@export var great_label: Label
@export var good_label: Label
@export var miss_label: Label
@export var accuracy_label: Label
#endregion

@export_category("Scores")
@export var bgm_progress_bar: TextureProgressBar
@export var score_label: Label
@export var rating_label: Label
@export var combo_label: Label

@export_category("Managers")
@export var data_loader: PlaySceneDataLoader
@export var audio_manager: AudioManager
@export var track_manager: TrackManager
@export var score_manager: ScoreManager
@export var time_manager: GameTime
@export var game_manager: GameManager

@export_category("UIGroup")
@export var pause_ui: Control

@export_category("DebugButtons")
@export var start_button: Button
@export var select_button: Button
@export var reset_button: Button
@export var auto_play_button: Button

@export_category("Dialogs")
@export var notice_window: Window
@export var file_dialog: FileDialog
@export var alert_dialog: AcceptDialog

var rating_label_setting: LabelSettings

func _ready() -> void:
	await get_tree().process_frame
	_reset_label_text_debug()
	
	if not data_loader.beatmap_info:
		_reset_notes_info()
	
	rating_label_setting = rating_label.label_settings
	set_process(false)

func _process(delta: float) -> void:
	if audio_manager.bgm_player.playing:
		bgm_progress_bar.value = (audio_manager.bgm_player.get_playback_position() / audio_manager.audio_length) * 1000.0

#region DebugUI
func _update_notes_info():
	if data_loader.beatmap_info:
		tap_count_label.text = TAP_TEXT.format([track_manager.note_data.get_tap_count()])
		hold_count_label.text = HOLD_TEXT.format([track_manager.note_data.get_hold_count()])
		total_count_label.text = TOTAL_TEXT.format([track_manager.note_data.get_note_count()])
	
	audio_length_label.text = _convert_second_to_minute(audio_manager.audio_length)

func _reset_notes_info():
	tap_count_label.text = TAP_TEXT.format([0])
	hold_count_label.text = HOLD_TEXT.format([0])
	total_count_label.text = TOTAL_TEXT.format([0])
	
	audio_length_label.text = _convert_second_to_minute(0)

func _convert_second_to_minute(time: float) -> String:
	var minute: int = time / 60
	var second: int = int(time) % 60
	
	return AUDIO_TIME_TEXT % [minute, second]

func _change_label_text_debug():
	marvelous_label.text = MARVELOUS_LABEL_TEXT.format([score_manager.marvelous_count])
	perferct_label.text = PERFECT_LABEL_TEXT.format([score_manager.perfect_count])
	great_label.text = GREAT_LABEL_TEXT.format([score_manager.great_count])
	good_label.text = GOOD_LABEL_TEXT.format([score_manager.good_count])
	miss_label.text = MISS_LABEL_TEXT.format([score_manager.miss_count])
	accuracy_label.text = ACCURACY_LABEL_TEXT % score_manager.accuracy

func _reset_label_text_debug():
	marvelous_label.text = MARVELOUS_LABEL_TEXT.format([0])
	perferct_label.text = PERFECT_LABEL_TEXT.format([0])
	great_label.text = GREAT_LABEL_TEXT.format([0])
	good_label.text = GOOD_LABEL_TEXT.format([0])
	miss_label.text = MISS_LABEL_TEXT.format([0])
	accuracy_label.text = ACCURACY_LABEL_TEXT % 0.0

#endregion

func _change_score_and_combo_text(): 
	if score_manager.combo_count < 5:
		combo_label.visible = false
	else :
		combo_label.visible = true
	
	combo_label.text = str(score_manager.combo_count)
	score_label.text = "%07d" % int(score_manager.accuracy * 10000)

func _change_rating_text(rating: JudgeManager.RatingTap):
	match rating:
		JudgeManager.RatingTap.MARVELOUS:
			rating_label.text = "MARVELOUS"
			rating_label_setting.font_color = MARVELOUS_COLOR
		JudgeManager.RatingTap.PERFECT:
			rating_label.text = "PERFECT"
			rating_label_setting.font_color = PERFECT_COLOR
		JudgeManager.RatingTap.GREAT:
			rating_label.text = "GREAT"
			rating_label_setting.font_color = GREAT_COLOR
		JudgeManager.RatingTap.GOOD:
			rating_label.text = "GOOD"
			rating_label_setting.font_color = GOOD_COLOR
		JudgeManager.RatingTap.MISS:
			rating_label.text = "MISS"
			rating_label_setting.font_color = MISS_COLOR
	
	rating_label_anim()

func _reset_score_and_combo_and_rating_text():
	combo_label.visible = false
	combo_label.text = ""
	score_label.text = "%07d" % 0
	rating_label.text = ""

func _reset_bgm_progress_bar():
	bgm_progress_bar.value = 0.0

#region TweenAnim
func scene_fade_in_anim():
	var scene_root: Control = get_tree().current_scene
	scene_root.modulate = Color.TRANSPARENT
	
	var tween: Tween = create_tween()
	tween.tween_property(scene_root, "modulate", Color.WHITE, 1.0).set_trans(Tween.TRANS_CIRC)

func scene_fade_out_anim() -> Tween:
	var scene_root: Control = get_tree().current_scene
	var tween: Tween = create_tween()
	tween.tween_property(scene_root, "modulate", Color.TRANSPARENT, 1.0).set_trans(Tween.TRANS_CIRC)
	return tween

func continue_anim() -> Tween:
	var tween: Tween = create_tween()
	tween.tween_property(pause_ui, "modulate", Color.TRANSPARENT, 3.0)
	return tween

func rating_label_anim():
	var tween: Tween = create_tween()
	tween.tween_property(rating_label, "scale", Vector2(1.1, 1.1), 0.05)
	tween.tween_property(rating_label, "scale", Vector2(1.0, 1.0), 0.05)
#endregion

func _unhandled_key_input(event: InputEvent) -> void:
	var key_event: InputEventKey = event
	if key_event.is_action_pressed("key_stop_play") and time_manager.pause_wait_timer.is_stopped():
		game_manager.pause_game.emit()

#region SignalsCallable
func _on_data_loader_loading_finished() -> void:
	_update_notes_info()

func _on_game_manager_continue_game() -> void:
	await continue_anim().finished
	pause_ui.visible = false
	pause_ui.modulate = Color.WHITE

func _on_debug_button_pressed() -> void:
	if data_loader.beatmap_info and audio_manager.bgm_player.stream:
		game_manager.start_game.emit()
	else :
		alert_dialog.dialog_text = tr("NO_FILE_TEXT")
		alert_dialog.popup()

func _on_select_file_button_pressed() -> void:
	file_dialog.popup()

func _on_reset_button_pressed() -> void:
	game_manager.reset_all.emit()
	start_button.disabled = false
	select_button.disabled = false
	reset_button.disabled = false

func _on_score_manager_update_scores() -> void:
	_change_score_and_combo_text()
	_change_label_text_debug()

func _on_judge_manager_update_judge_rating(rating: JudgeManager.RatingTap) -> void:
	_change_rating_text(rating)

func _on_game_manager_start_game() -> void:
	start_button.disabled = true
	select_button.disabled = true
	reset_button.disabled = true
	auto_play_button.disabled = true

func _on_game_manager_end_game() -> void:
	reset_button.disabled = false
	set_process(false)

func _on_game_manager_reset_all() -> void:
	_reset_notes_info()
	_reset_label_text_debug()
	_reset_score_and_combo_and_rating_text()
	_reset_bgm_progress_bar()

func _on_pause_button_pressed() -> void:
	if time_manager.pause_wait_timer.is_stopped():
		pause_ui.visible = true
		game_manager.pause_game.emit()

func _on_continue_button_pressed() -> void:
	pause_ui.visible = false
	await continue_anim()
	game_manager.continue_game.emit()

func _on_reload_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_window_close_requested() -> void:
	notice_window.hide()

func _on_auto_play_button_pressed() -> void:
	track_manager.auto_play_mode = not track_manager.auto_play_mode
	if auto_play_button.button_pressed:
		auto_play_button.text = tr("AUTO_ON")
	else :
		auto_play_button.text = tr("AUTO_OFF")
#endregion
