# 0v0Mania - 类似于 osu!mania 的 4K 下落式音游Demo
<img src= https://github.com/Voice-of-Sunflower/0V0Mania-Demo/blob/0.4.0-alpha/Screenshots/0.4.0%20screenshot%201.png width="30%" /> <img src= https://github.com/Voice-of-Sunflower/0V0Mania-Demo/blob/0.4.0-alpha/Screenshots/0.4.0%20screenshot%202.png width="30%" />
<img src= https://github.com/Voice-of-Sunflower/0V0Mania-Demo/blob/0.4.0-alpha/Screenshots/0.4.0%20screenshot%203.png width="30%" />

**v0.4.0版本视频演示地址（哔哩哔哩）**：https://b23.tv/c9IYgM5

一款使用 **Godot 引擎** 开发的类似于 **osu!mania** 的 **4K** 下落式音乐游戏。

## 🎮 游戏特点

*   **经典 4K 玩法**：熟悉的 4 键垂直下落式谱面，带来纯粹的音游体验。
*   **自定义谱面支持**：支持导入和播放osu!社区制作的谱面文件。
*   **精准的判定系统**：设计了严谨的判定区间，确保游戏公平且有挑战性。
*   **灵活的键位设置**：允许玩家自定义键盘按键，以适应不同的操作习惯。
*   **视觉反馈**：击中音符时有华丽的打击特效和连击显示，提供爽快的操作反馈。

## 🎯 相比于 osu!mania 的改进

虽然灵感来源于 osu!mania，但本作在核心机制和体验上做出了独特改进：

1.  **创新的判定系统**：
    *   借鉴了 **maimai DX（舞萌DX）** 的判定机制，去除了音符尾部的延迟判定，提供更直观的打击感。
    *   **Hold 音符** 中断时不会丢失连击，降低了因短暂失误导致的挫败感，同时保持了游戏流畅性。

2.  **简洁干净的界面**：
    *   UI 设计遵循极简原则，仅保留游玩所需的核心信息。
    *   相较于 osu! 更少的主界面元素干扰，让玩家能够更专注于游玩本身。

3.  **可自定义的难度系统**：
    *   当谱面难度不合理时，玩家可以自行调整谱面难度。
    *   未来计划在更多机制上添加客制化选项，让每位玩家都能找到最适合自己的挑战方式。

## 🕹️ 如何游玩

1.  从 `Releases` 页面下载最新版本并解压游戏。
2.  运行游戏主程序 `0v0Mania.exe`。
3.  前往OSU官网谱面列表 https://osu.ppy.sh/beatmapsets?m=3&q=key%3D4 中下载osz谱面导入游戏
4.  选择你喜欢的歌曲和难度。
5.  当音符落到判定线时，按下对应的按键！

## 📥 下载与安装

### 最新版本

前往项目的 [Releases 页面](https://github.com/Voice-of-Sunflower/0V0Mania-Demo/releases) 下载最新版本的游戏。

**系统要求:**
*   **操作系统**: Windows 10/11
*   **存储空间**: 约 150 MB 可用空间

### 从源代码运行

如果您想自行编译或贡献代码，请遵循以下步骤：

⚠️ **注意**：0.4.0版本后，仅公开游玩场景下的源码。

1.  **克隆仓库**:
    ```bash
    git clone https://github.com/Voice-of-Sunflower/0V0Mania-Demo.git
    cd 0V0Mania-Demo
    ```

2.  **使用 Godot 打开**:
    *   确保您已安装 [Godot 4.4.1](https://godotengine.org/download/)。
    *   使用 Godot 编辑器打开项目文件夹 (`project.godot` 文件)。

3.  **运行**:
    *   在编辑器中直接点击 `运行` 按钮进行测试。

## 📦 第三方组件

本项目使用了以下优秀的开源组件：

| 组件名称 | 用途 | 许可证 |
|---------|------|--------|
| [godot-midi-mport](https://github.com/G0retZ/godot-midi-mport) | 在`v0.1.0 - v0.2.0`版本中使用，用于解析midi文件 | [MIT](https://github.com/G0retZ/godot-midi-mport/blob/main/LICENSE) |
| [SmoothScroll](https://github.com/SpyrexDE/SmoothScroll) | `v0.4.0`版本以上使用，用于创建平滑动画的谱面列表 | [MIT](https://github.com/SpyrexDE/SmoothScroll/blob/godot-4/LICENSE) |

## 🎵 自定义谱面

我们欢迎社区创作的歌曲/谱面！可惜的是目前游戏还尚未开发制谱器，如果你想为游戏制作谱面，请使用 **osu!** 的制谱器制作。

谱面文件通常应放置于游戏目录下的 `Beatmaps/` 文件夹中。

## 🛠️ 技术栈

*   **游戏引擎**: Godot 4.4.1
*   **编程语言**: GDScript
*   **主要功能**: 音频同步、输入处理、UI 动画、自定义资源加载

## 👥 贡献

我们欢迎任何形式的贡献！包括但不限于：
*   💻 提交代码修复或新功能
*   🌐 帮助翻译游戏
*   📝 报告 Bug 或提出建议

请 Fork 本仓库并提交 Pull Request 来贡献代码。

## 📜 许可证

本项目基于 [MIT License](https://github.com/Voice-of-Sunflower/0V0Mania-Demo/blob/0.4.0-alpha/LICENSE) 开源。

游戏内使用的音乐资源版权归其原作者所有，仅用于学习和测试目的。

## 🏷️ 版本更新记录
### v0.4.0 alpha 250904
- 紧急修复osu谱面中ogg格式音乐文件加载的问题

### v0.4.0 alpha 250901
- **[UI] 重构了几乎所有的UI布局**
- [UI] 简化了谱面物件交互逻辑
- [UI] 部分UI交互添加了动画
- **[文件系统] 重构了谱面和关卡文件结构**
- [文件系统] 谱面和关卡支持更多元数据
- [文件系统] 更人性化的谱面关卡创建
- **[游玩] 对于音符的生成和判定进行了性能优化**
- [游玩] 更换了音符的材质
- [游玩] 添加了游玩分数记录

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
