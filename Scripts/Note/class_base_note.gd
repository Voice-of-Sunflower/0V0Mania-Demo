extends Node2D
class_name BaseNote

#region 颜色和材质
const origin_color: Color = Color.WHITE
const miss_color: Color = Color.DARK_GRAY
var note_material: ShaderMaterial
#endregion

#region 材质和着色器
@export var note_texture: TextureRect
@export var texture_style_1: GradientTexture2D
@export var texture_style_2: GradientTexture2D
@export var shader: ShaderMaterial = preload("res://Resources/Shader/note_shader.tres")
#endregion

#region 节点组
## 轨道父节点
var track_node: NoteTrack
## 判定管理节点
var judge_manager: JudgeManager
## 音符对象池
var note_object_pool: NoteObjectPool
## 时间管理节点
var time_manager: GameTime
#endregion

## notelock方案2
#var is_lock: bool = true

## 自动播放
var auto_play: bool = false

## 开始落下到判定线的时间差
var time_difference: float

## 用于和轨道节点的current_note_index比对防止叠判(notelock)
var note_index: int

## 用于匹配按键
var track_index: int

#region 时间相关变量
var note_time_stamp: int
var elasped_time: int
#endregion

#region 位置与速度变量
var speed: int = GlobalSettings.fall_speed * 50
var init_pos_y: int
var length: float = 35.0
#endregion

func init_material():
	note_material = shader.duplicate()
	note_texture.material = note_material
	note_material.set_shader_parameter("base_color", origin_color)

func init_nodes(jud_node: JudgeManager, pool_node: NoteObjectPool, tr_node: NoteTrack, time_node: GameTime):
	judge_manager = jud_node
	note_object_pool = pool_node
	track_node = tr_node
	time_manager = time_node

func init_texture():
	if track_index == 2 or track_index == 3:
		note_texture.texture = texture_style_2

func init_start_position(pos_y: int):
	position.y = pos_y - length
	init_pos_y = position.y

func reset_all_variables():
	note_texture.texture = texture_style_1
	note_material = shader
	
	track_node = null
	
	note_index = -1
	track_index = -1
	
	note_time_stamp = -1
	elasped_time = -1
	
	init_pos_y = -1000
