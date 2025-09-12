# 0v0Mania - 4K Rhythm Game Demo Similar to osu!mania
<img src= https://github.com/Voice-of-Sunflower/0V0Mania-Demo/blob/0.4.0-alpha/Screenshots/0.4.0%20screenshot%201.png width="30%" /> <img src= https://github.com/Voice-of-Sunflower/0V0Mania-Demo/blob/0.4.0-alpha/Screenshots/0.4.0%20screenshot%202.png width="30%" />
<img src= https://github.com/Voice-of-Sunflower/0V0Mania-Demo/blob/0.4.0-alpha/Screenshots/0.4.0%20screenshot%203.png width="30%" />

A **4K** vertical scrolling rhythm game similar to **osu!mania**, developed using the **Godot Engine**.

## 🎮 Game Features

*   **Classic 4K Gameplay**: Familiar 4-key vertical scrolling beatmaps for a pure rhythm game experience.
*   **Custom beatmap Support**: Supports importing and playing beatmaps created by the osu! community.
*   **Precise Scoring System**: Features a strict judgment window (Marvelous, Perfect, Great, Good, Miss, etc.) to ensure fair and challenging gameplay.
*   **Customizable Key Bindings**: Allows players to customize keyboard keys to suit different play styles.
*   **Visual Feedback**: Provides satisfying hit effects and combo displays when hitting notes.

## 🎯 Improvements Compared to osu!mania

While inspired by osu!mania, this game introduces unique improvements to core mechanics and user experience:

1.  **Innovative Scoring System**:
    *   Adopts the judgment mechanics from **maimai DX**, removing delayed judgment at note tails for more intuitive hit feedback.
    *   **Hold notes** do not break combo when released early, reducing frustration from minor mistakes while maintaining gameplay flow.

2.  **Clean and Minimalist Interface**:
    *   UI design follows minimalism principles, keeping only essential gameplay information visible.
    *   Fewer UI elements compared to osu!, allowing players to focus more on the gameplay itself.

3.  **Customizable Difficulty System**:
    *   Players can adjust beatmap difficulty when they find it unreasonable.
    *   Plans to add more customizable options in future updates, allowing each player to find their optimal challenge level.

## 🕹️ How to Play

1.  Download the latest version from the `Releases` page and extract the game.
2.  Run the main executable `0v0Mania.exe`.
3.  Download `.osz` beatmaps from the OSU official website: https://osu.ppy.sh/beatmapsets?m=3&q=key%3D4 and import them into the game.
4.  Select your preferred song and difficulty.
5.  Press the corresponding keys when notes reach the judgment line!

## 📥 Download & Installation

### Latest Version

Visit the project's [Releases page](https://github.com/Voice-of-Sunflower/0V0Mania-Demo/releases) to download the latest version.

**System Requirements:**
*   **OS**: Windows 10/11
*   **Storage**: Approximately 150 MB available space

### Running from Source Code

If you want to compile or contribute to the code, follow these steps:

⚠️ **Note**: Since version 0.4.0, only the gameplay scene source code is publicly available.

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/Voice-of-Sunflower/0V0Mania-Demo.git
    cd 0V0Mania-Demo
    ```

2.  **Open with Godot**:
    *   Ensure you have [Godot 4.4.1](https://godotengine.org/download/) installed.
    *   Open the project folder (`project.godot` file) with the Godot editor.

3.  **Make necessary configuration adjustments**:
    *   Adjust game settings in the `Scripts/SimpleSetting` node, particularly the language (cannot be changed after game launch).

4.  **Run**:
    *   Click the `Run` button in the editor to test.

## 📦 Third-Party Components

This project uses the following excellent open-source components:

| Component Name | Purpose | License |
|---------|------|--------|
| [godot-midi-import](https://github.com/G0retZ/godot-midi-mport) | Used in `v0.1.0 - v0.2.0` for MIDI file parsing | [MIT](https://github.com/G0retZ/godot-midi-mport/blob/main/LICENSE) |
| [SmoothScroll](https://github.com/SpyrexDE/SmoothScroll) | Used in `v0.4.0+` for creating smooth animated beatmap lists | [MIT](https://github.com/SpyrexDE/SmoothScroll/blob/godot-4/LICENSE) |

## 🎵 Custom beatmaps

We welcome community-created songs/beatmaps! Unfortunately, the game doesn't have a built-in beatmap editor yet. If you want to create beatmaps for the game, please use **osu!**'s editor.

beatmap files should typically be placed in the `Beatmaps/` folder within the game directory.

## 🛠️ Tech Stack

*   **Game Engine**: Godot 4.4.1
*   **Programming Language**: GDScript
*   **Main Features**: Audio synchronization, input handling, UI animation, custom resource loading

## 👥 Contribution

We welcome contributions in any form! Including but not limited to:
*   💻 Submitting code fixes or new features
*   🌐 Helping with game translation
*   📝 Reporting bugs or suggesting improvements

Please fork this repository and submit a Pull Request to contribute code.

## 📜 License

This project is open source under the [MIT License](https://github.com/Voice-of-Sunflower/0V0Mania-Demo/blob/0.4.0-alpha/LICENSE).

Music resources used in the game belong to their original authors and are for learning and testing purposes only.

## 🏷️ Version History
### v0.4.0 alpha 250904
- Hotfix for OGG audio file loading issues in osu beatmaps

### v0.4.0 alpha 250901
- **[UI] Redesigned almost all UI layouts**
- [UI] Simplified beatmap object interaction logic
- [UI] Added animations for some UI interactions
- **[File System] Restructured beatmap and level file architecture**
- [File System] beatmaps and levels now support more metadata
- [File System] More user-friendly beatmap level creation
- **[Gameplay] Performance optimization for note generation and judgment**
- [Gameplay] Updated note materials
- [Gameplay] Added gameplay score recording

### v0.2.0
- **[New Experimental Feature] Support for osu 4k mania beatmap import (supports BPM changes but without speed variation effects)**
- [Bug Fix] Fixed overlapping notes at the beginning
- [Bug Fix] Fixed missed judgment issues with short hold notes
- [Bug Fix] Improved note flag variable stacking method
- [Optimization] Modified buttons to accommodate longer level names
- [Optimization] beatmaps now support right-click context menus
- [Optimization] Partial code refactoring
- [Optimization] Minor gameplay interface adjustments

### v0.1.2
- Fixed overlapping judgment issue when note interval is less than 75ms
- Fixed drag judgment issues with hold note tail judgments
- Updated engine version to `Godot 4.4`

### v0.1.1
- Added localization support (currently English and Simplified Chinese)
- Added beatmap export functionality

### v0.1.0
- Initial version with basic features implemented
