extends Panel
class_name GameKeyItem

@export var countdown_timer: Timer
@export var key_hint: Label

const origin_color: Color = Color.DIM_GRAY
const press_color: Color = Color.GRAY

var key_index: String
var key_shader: ShaderMaterial

func _ready() -> void:
	countdown_timer.timeout.connect(_on_countdown_over)
	get_key_index()
	set_key_hint_text()
	key_shader = material.duplicate()
	material = key_shader

func set_key_hint_text():
	match key_index:
		"1":
			key_hint.text = get_key_name(&"Key_1")
		"2":
			key_hint.text = get_key_name(&"Key_2")
		"3":
			key_hint.text = get_key_name(&"Key_3")
		"4":
			key_hint.text = get_key_name(&"Key_4")

func get_key_name(action_name: StringName) -> String:
	var key_event: InputEventKey = InputMap.action_get_events(action_name)[0]
	var key_name: String = key_event.as_text_physical_keycode()
	return key_name

func get_key_index():
	key_index = name.trim_prefix("Key")

func key_hint_anim():
	var tween: Tween = create_tween()
	tween.tween_property(key_hint, "modulate", Color.TRANSPARENT, 3.0)

func _on_countdown_over():
	key_hint_anim()

func _unhandled_key_input(event: InputEvent) -> void:
	var key_event: InputEventKey = event
	
	if key_event.is_action_pressed("Key_" + key_index):
		key_shader.set_shader_parameter("light_strength", 0.3)
	
	if key_event.is_action_released("Key_" + key_index):
		key_shader.set_shader_parameter("light_strength", 0.0)
