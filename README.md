# NoteMania - 4K下落式音游Demo
### This document is only Chinese now
<img src= https://github.com/thefoxIncode/NoteMania-Demo/blob/main/Screenshots/1.png width="40%" /> <img src= https://github.com/thefoxIncode/NoteMania-Demo/blob/main/Screenshots/2.png width="40%" />
<img src= https://github.com/thefoxIncode/NoteMania-Demo/blob/main/Screenshots/3.png width="40%" /> <img src= https://github.com/thefoxIncode/NoteMania-Demo/blob/main/Screenshots/4.png width="40%" />

使用 Godot 4 引擎开发的4K下落式音乐游戏原型，支持MIDI谱面导入与自定义谱面制作。

视频演示地址：https://www.bilibili.com/video/BV1mWAfeGEWZ

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
- 偶发叠判（已修复）

## 📥 安装与使用
### 依赖项
- Godot 4.2.2+ (v0.1.2 前)
- Godot 4.4+ (v0.1.2 后)

### 快速开始
1. 克隆本仓库
2. 在Godot中导入项目
4. 运行`beatmap_list_ui.tscn`

### 谱面制作指南
（WIP）

## 🚧 开发计划
- [x] 优化谱面容错解析系统
- [ ] 完善谱面制作指南
- [ ] 改进音频同步算法
- [ ] 开发可视化谱面编辑器

## 🏷️ 更新日志
### v0.2.0
- **[新增试验性功能] 支持osu 4k mania谱面导入（支持BPM变化的谱面，但不会有变速效果）**
- [修复BUG] 修复开头note堆叠的问题
- [修复BUG] 修复短hold的漏判问题
- [修复BUG] 改进note标记变量的叠加方式
- [优化] 修改按钮适应长关卡名的显示
- [优化] 现在谱面支持右键弹出编辑菜单
- [优化] 部分代码进行重构
- [优化] 微调游玩界面

### v0.1.2
- 修复了两个note间隔小于75ms时会发生叠判的问题
- 修复了hold尾判出现的拖判问题
- 更新引擎版本为 `Godot 4.4`

### v0.1.1
- 添加了本地化，目前支持英文和简体中文
- 添加谱面导出功能

### v0.1.0
- 第一个版本，基本功能完善

## 📄 许可协议
本项目源码遵循 MIT 协议，使用插件请遵守其对应协议：
- godot-midi-import: [MIT](https://github.com/G0retZ/godot-midi-mport?tab=MIT-1-ov-file)
