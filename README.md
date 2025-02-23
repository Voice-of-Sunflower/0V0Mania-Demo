# NoteMania - 4K下落式音游Demo

<img src= https://github.com/thefoxIncode/NoteMania-Demo/blob/main/Screenshots/1.png width="40%" /> <img src= https://github.com/thefoxIncode/NoteMania-Demo/blob/main/Screenshots/2.png width="40%" />
<img src= https://github.com/thefoxIncode/NoteMania-Demo/blob/main/Screenshots/3.png width="40%" /> <img src= https://github.com/thefoxIncode/NoteMania-Demo/blob/main/Screenshots/4.png width="40%" />

使用 Godot 4 引擎开发的4K下落式音乐游戏原型，支持MIDI谱面导入与自定义谱面制作。

## ℹ️ 项目中使用的插件
- [godot-midi-import](https://github.com/G0retZ/godot-midi-mport) - MIDI导入功能 by [G0retZ] (MIT License)

## ✨ 主要特点
### 1. 经典4K下落式玩法
- 完全复刻标准4键下落式音游体验
- 支持多种判定精度显示

### 2. 高度可定制化设置
- 音符下落速度调节
- 判定偏移设置
- 音效音量独立控制
- 自定义打击按键

### 3. 自定义谱面支持
- 支持标准MIDI文件导入（需符合格式规范）

## ⚠️ 当前限制
### 音频同步
- 打击音效与音乐存在偏差
- 偶发叠判

## 📥 安装与使用
### 依赖项
- Godot 4.2.2+

### 快速开始
1. 克隆本仓库
2. 在Godot中导入项目
4. 运行`beatmap_list_ui.tscn`

### 谱面制作指南
（WIP）

## 🚧 开发计划
- [ ] 完善谱面制作指南
- [ ] 优化谱面容错解析系统
- [ ] 改进音频同步算法
- [ ] 开发可视化谱面编辑器

## 📄 许可协议
本项目源码遵循 MIT 协议，使用插件请遵守其对应协议：
- godot-midi-import: [MIT](https://github.com/G0retZ/godot-midi-mport?tab=MIT-1-ov-file)

## 🤝 参与贡献
欢迎通过Issue提交建议！
