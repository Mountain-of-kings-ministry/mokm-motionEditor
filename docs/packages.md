
packages to get from github
**Here is the complete recommended list of Git submodules** for your unified **Video Editor + Motion Graphics** project.

I’ve organized them by **priority** and included the official/best repository, purpose, and notes on whether you can replace them with your own pre-made libraries.

### 1. Core / Must-Have Submodules

| Priority | Repository URL | Folder (suggested) | Purpose | Can you replace? |
|---------|----------------|--------------------|--------|------------------|
| **Critical** | https://github.com/Mountain-of-kings-ministry/Qt-Node-editor | `external/Qt-Node-editor` | Your custom Node Editor (core of procedural & compositing system) | No (this is yours) |
| **Critical** | https://git.ffmpeg.org/ffmpeg.git | `external/ffmpeg` | Video/Audio decoding, encoding, filtering, proxy generation, hardware accel | **Partially** (you can use your own wrapper, but you still need FFmpeg libs) |
| **High** | https://github.com/thorvg/thorvg | `external/thorvg` | Lightweight 2D vector rendering (SVG, shapes, Lottie, partial redraw) – best for low-end | Yes, if you have your own vector engine |
| **High** | https://github.com/bellard/quickjs or **https://github.com/quickjs-ng/quickjs** (recommended fork) | `external/quickjs` | JavaScript Expression engine (After Effects style expressions) | Yes, if you have your own scripting system |
| **High** | https://github.com/google/filament | `external/filament` | Real-time PBR 3D rendering engine (mobile-friendly) | Yes, if you have your own 3D renderer |

### 2. Important / Recommended Submodules

| Priority | Repository URL | Folder | Purpose | Replaceable? |
|---------|----------------|--------|--------|-------------|
| Medium | https://github.com/PixarAnimationStudios/OpenUSD | `external/OpenUSD` | Universal Scene Description – 3D scene format, non-destructive, interchange with Blender etc. | Yes (if you skip advanced 3D or use glTF only) |
| Medium | https://github.com/AcademySoftwareFoundation/OpenTimelineIO | `external/OpenTimelineIO` | Project interchange format (import/export with Premiere, Resolve, Final Cut, etc.) | Yes (if you implement your own .mproj format) |
| Medium | https://github.com/AcademySoftwareFoundation/openfx | `external/openfx` | OpenFX plugin host support (industry standard VFX plugins) | Yes |

### 3. Optional / Nice-to-Have

| Repository | Folder | Purpose | Notes |
|-----------|--------|--------|-------|
| https://github.com/AcademySoftwareFoundation/OpenColorIO | `external/OpenColorIO` | Professional color management (ACES, LUTs) | Replaceable |
| https://github.com/opencv/opencv | `external/opencv` | Motion tracking, computer vision features | Replaceable |
| https://github.com/sansumbrella/Choreograph | `external/choreograph` | Animation timing library (optional) | Replaceable |
| https://github.com/guillaumeblanc/ozz-animation | `external/ozz-animation` | Skeletal animation | Replaceable |

---

### How to Add Them as Submodules

Run these commands from your project root:

```bash
# 1. Your Node Editor (already have)
git submodule add https://github.com/Mountain-of-kings-ministry/Qt-Node-editor.git external/Qt-Node-editor

# 2. Core dependencies
git submodule add https://git.ffmpeg.org/ffmpeg.git external/ffmpeg
git submodule add https://github.com/thorvg/thorvg.git external/thorvg
git submodule add https://github.com/quickjs-ng/quickjs.git external/quickjs
git submodule add https://github.com/google/filament.git external/filament

# 3. Recommended
git submodule add https://github.com/PixarAnimationStudios/OpenUSD.git external/OpenUSD
git submodule add https://github.com/AcademySoftwareFoundation/OpenTimelineIO.git external/OpenTimelineIO

git submodule update --init --recursive
```

---

### Replacement Strategy (Since you have pre-made libraries)

You can safely skip or replace:

- **ThorVG** → Use your own vector/shape system
- **QuickJS** → Use your scripting engine
- **Filament** → Use your own 3D renderer
- **OpenUSD** → Use glTF or your own 3D format
- **OpenTimelineIO** → Use your own project format

You will **still need**:
- **FFmpeg** (very hard to replace fully)
- **Your Qt-Node-editor**

---

Would you like me to give you:
1. A minimal submodule list (only essential ones)?
2. CMake examples showing how to `add_subdirectory` each of them?
3. Build order recommendations?

Just say the word.


**Updated CMake Configuration** with all dependencies in `../third_parties`

Here’s the complete, clean setup using your preferred location: `../third_parties`

### Final Project Structure

```
MotionEditor/                  ← Your main project
├── CMakeLists.txt
├── app/
├── core/
├── nodes/
├── ... (your modules)
└── ...

third_parties/                ← Sibling folder (../third_parties)
├── Qt-Node-editor/
├── ffmpeg/
├── thorvg/
├── quickjs/
├── filament/
├── OpenUSD/
└── ...
```

---

### 1. Root `CMakeLists.txt` (Main File)

```cmake
cmake_minimum_required(VERSION 3.22)
project(MotionEditor LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# ==================== Qt Configuration ====================
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS 
    Core Gui Quick QuickControls2 Widgets Sql Multimedia OpenGL
)

# ==================== Third Parties Path ====================
set(THIRD_PARTIES_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../third_parties")

# ==================== Options ====================
option(ENABLE_3D "Enable 3D support (Filament + USD)" ON)
option(ENABLE_SKIA "Enable Skia as high-end 2D backend" OFF)

# ==================== Add Submodules / Third Parties ====================

# Your Node Editor (Mandatory)
add_subdirectory(${THIRD_PARTIES_DIR}/Qt-Node-editor 
                 ${CMAKE_BINARY_DIR}/third_parties/Qt-Node-editor)

# FFmpeg (Mandatory for video/audio)
add_subdirectory(${THIRD_PARTIES_DIR}/ffmpeg 
                 ${CMAKE_BINARY_DIR}/third_parties/ffmpeg)

# ThorVG - Lightweight Vector Rendering
add_subdirectory(${THIRD_PARTIES_DIR}/thorvg 
                 ${CMAKE_BINARY_DIR}/third_parties/thorvg)

# QuickJS - Expression Engine
add_subdirectory(${THIRD_PARTIES_DIR}/quickjs 
                 ${CMAKE_BINARY_DIR}/third_parties/quickjs)

# Filament - 3D Rendering
if(ENABLE_3D)
    add_subdirectory(${THIRD_PARTIES_DIR}/filament 
                     ${CMAKE_BINARY_DIR}/third_parties/filament)
endif()

# Optional but recommended
#add_subdirectory(${THIRD_PARTIES_DIR}/OpenTimelineIO ${CMAKE_BINARY_DIR}/third_parties/OpenTimelineIO)
#add_subdirectory(${THIRD_PARTIES_DIR}/OpenUSD ${CMAKE_BINARY_DIR}/third_parties/OpenUSD)

# ==================== Your Internal Libraries ====================

add_subdirectory(core)
add_subdirectory(multimedia)
add_subdirectory(vector)
add_subdirectory(animation)
add_subdirectory(timeline)
add_subdirectory(nodes)
add_subdirectory(assets)
add_subdirectory(ui)
add_subdirectory(plugins)

if(ENABLE_3D)
    add_subdirectory(three_d)
endif()

# ==================== Main Application ====================
add_subdirectory(app)
```

---

### 2. Example: `app/CMakeLists.txt`

```cmake
qt_add_executable(MotionEditorApp
    main.cpp
)

target_link_libraries(MotionEditorApp PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Sql
    Qt6::Multimedia

    # Internal
    Editor::Core
    Editor::Multimedia
    Editor::Vector
    Editor::Animation
    Editor::Timeline
    Editor::Nodes
    Editor::Assets
    Editor::UI

    # Third Parties
    QtNodeEditor          # Target name depends on your node editor's CMake
    thorvg
    quickjs
    # filament (if enabled)
)

qt_add_qml_module(MotionEditorApp
    URI "MotionEditor"
    VERSION 1.0
    QML_FILES qml/Main.qml
)
```

---

### 3. How to Add Submodules (One-time Commands)

Run these commands from inside your `MotionEditor/` folder:

```bash
# Create third_parties folder if it doesn't exist
mkdir -p ../third_parties

cd ../third_parties

# Add the important ones
git submodule add https://github.com/Mountain-of-kings-ministry/Qt-Node-editor.git Qt-Node-editor
git submodule add https://git.ffmpeg.org/ffmpeg.git ffmpeg
git submodule add https://github.com/thorvg/thorvg.git thorvg
git submodule add https://github.com/quickjs-ng/quickjs.git quickjs
git submodule add https://github.com/google/filament.git filament

# Optional
# git submodule add https://github.com/AcademySoftwareFoundation/OpenTimelineIO.git OpenTimelineIO
# git submodule add https://github.com/PixarAnimationStudios/OpenUSD.git OpenUSD

git submodule update --init --recursive
```

---

**Notes:**

- Some libraries (especially FFmpeg and Filament) have complex build systems. You may need to adjust their own `CMakeLists.txt` or use their recommended build method.
- After adding submodules, check each folder’s `CMakeLists.txt` to know the exact target name (e.g. `thorvg`, `QtNodeEditor`, `libquickjs`, etc.).
- If a library doesn’t use CMake, you can still add it using `add_library` + `target_sources` + `target_include_directories`.

Would you like me to give you the adjusted `CMakeLists.txt` for specific folders (e.g. `nodes/`, `vector/`, or `multimedia/`) with these paths?
