**Comprehensive Structured Plan: Professional Node-Based Video Editor + Motion Graphics Suite**

This merged architecture creates a single, unified open-source application — a **hybrid Video Editor + Motion Graphics Platform** — that combines the strengths of both blueprints. It delivers professional non-linear video editing (with proxies for low-end hardware) and deep motion graphics capabilities (procedural, 2D/3D, expressions, responsive design) in one cohesive tool.

### 1. Overall System Architecture (Unified High-Level Flow)

**Core Philosophy**: One project file, one engine, seamless switching between editing and motion design workflows.

**Layered Architecture**:

- **Multimedia Core** (C++): FFmpeg (video I/O, decoding, encoding)
- **Vector & Shape Engine**: ThorVG (default) + Skia (optional high-end)
- **3D Engine**: Filament (PBR) + USD (scene description)
- **Animation & Logic Engine**: Node graph (QtNodes) + Timeline + QuickJS expressions + procedural tools
- **Asset & Proxy System**: Unified for video + motion assets
- **Rendering Pipeline**: Hybrid (GPU via Qt RHI + CPU fallback) with lazy evaluation
- **UI Layer**: Qt Quick (QML) with C++ backends
- **Plugin Layer**: OFX (video/effects), VST3/LV2/CLAP (audio), custom motion nodes
- **Interoperability**: OpenTimelineIO (OTIO) + USD + glTF

**Unified Data Flow** (Every Tool/Operation):

1. Import media/shape/3D asset → Asset Manager + Proxy/Optimization pass
2. Add to Timeline or Node Graph → creates Source Node (video, shape, USD prim, etc.)
3. User works in **Hybrid View**:
   - Timeline mode (layer stack, keyframes, editing)
   - Node Graph mode (procedural, complex compositing)
   - Toggle between them on the same composition
4. Playhead / Scrub → Pull request from Output Node → lazy evaluation through graph
5. Rendering:
   - Editing preview: Proxy + ThorVG/Filament
   - Motion preview: Real-time vector/3D
   - Final export: Full resolution + FFmpeg encode
6. Expressions / Behaviors / Duplicators update live via QuickJS or procedural solvers

**Threading Model** (unchanged + enhanced):
- UI Thread: Qt Quick Scene Graph
- Worker Pool: Decoding, proxy gen, heavy node cooking, 3D rendering
- Animation Thread: High-priority for smooth 60fps motion preview

**Mobile Support** (Android/iOS):
- Same codebase with conditional QML
- Forced low-res proxies + ThorVG + simplified Filament
- Touch gestures (pinch zoom, two-finger scrub, drag-to-trim)
- Battery-aware: throttle 3D/node complexity automatically

**Project Structure** (CMake):
```
MotionEditor/
├── core/                  # Shared types, nodes, animation
├── multimedia/            # FFmpeg video pipeline
├── vector/                # ThorVG + Skia abstraction
├── three_d/               # Filament + USD
├── animation/             # Keyframes, expressions, procedural
├── timeline/              # Multi-track + dope sheet
├── nodes/                 # QtNodes + custom motion nodes
├── assets/                # Database + proxies
├── ui/                    # QML + custom renderers
├── mobile/                # Platform overrides
├── plugins/               # OFX, audio, custom
└── app/
```

### 2. Asset & Proxy System (Merged)

**Process Flow**:
1. Import (video, image, vector, glTF, USD) → Metadata scan + hardware analysis
2. Generate proxies:
   - Video: H.264/540p or ProRes Proxy (as before)
   - Vector/Motion: Rasterized low-res preview + cached ThorVG scene
   - 3D: Lower-poly USD variant or baked textures
3. Store in SQLite: original path, proxy path, type, metadata, linked nodes
4. Dynamic Swap: Proxy during editing → full-res on HQ preview / final render

**Mobile**: Aggressive proxy + on-device generation with hardware encoders.

### 3. Node-Based Processing Engine (Enhanced for Motion)

**Process Flow (Pull-Based DAG)**:
1. Output Node requests frame at time T
2. Propagates backward:
   - Video nodes → FFmpeg decoder/proxy
   - Shape nodes → ThorVG renderer
   - 3D nodes → Filament render pass
   - Procedural nodes (Duplicator, Behavior) → generate instances
   - Effect nodes → GLSL or CPU (ThorVG filters)
3. Lazy + ROI: Only compute visible elements
4. Caching: Per-node frame cache with invalidation on param change
5. GPU Optimization: Combine shaders + Filament for 3D passes

**Key Node Types** (new motion additions):
- **Shape Generator Nodes**: Rectangle, Ellipse, Text, Path (ThorVG)
- **Duplicator Node**: Procedural replication (grid, circle, path, data-driven)
- **Behavior Node**: Physics, follow, wiggle, data binding
- **USD/3D Node**: Load prim, camera, lighting
- **Expression Node**: QuickJS binding
- **Video Source / Compositing Nodes** (from original plan)

**Hybrid Sync**: Changes in node graph instantly reflected in timeline layers and vice versa.

### 4. Timeline & Editing Engine (Hybrid)

**Process Flow**:
1. `TimelineModel` manages tracks, clips, and layers
2. Each layer can be:
   - Traditional video clip
   - Motion composition (with nested node graph)
   - Procedural shape layer
3. Dope Sheet + Graph Editor for keyframes (Bezier via Qt or custom)
4. Responsive Layout System: Elements anchored relatively (left/right/top/bottom + percentages) — auto-adapts to output resolution (16:9 → 9:16 etc.)

**Motion-Specific Features**:
- Camera track (2D/3D)
- Pre-composition / nested comps (as sub-graphs)
- Procedural animation layers

### 5. Animation & Motion Systems

**Core Engines**:
- **Keyframe Animation**: Qt Timeline + custom Bezier interpolator
- **Expressions**: QuickJS engine bound to node properties (e.g., `opacity = audioLevel * 2`)
- **Procedural**: Duplicators + Behaviors (C++ solvers + Choreograph/ozz-animation for skeletal)
- **Physics / Dynamics**: Integrated simple rigid body or particle system (can be extended via plugins)

**Responsive Design Engine**:
- Master composition with relative anchors and adaptive rules
- One design → multiple aspect ratios with minimal rework

**3D Workflow**:
- Import glTF/USD
- Filament real-time PBR preview
- Camera animation (position, focal length, aperture) keyframed or procedural
- Depth compositing with 2D layers

**2D Vector Rendering Strategy**:
- Default: ThorVG (lightweight, partial redraw)
- High-end: Switch to Skia via abstraction layer
- Blend2D for performance-critical CPU paths

### 6. Rendering Pipeline (Unified)

**Preview Modes**:
- Editing: Proxy + fast ThorVG/Filament
- Motion Design: Real-time 60fps (vector + 3D)
- Final Render: Full resolution, multi-pass (video + motion + 3D) → FFmpeg

**Optimization Techniques**:
- Smart partial rendering (ThorVG)
- Zero-copy where possible
- SIMD for CPU paths
- Hardware acceleration (FFmpeg + Filament)

### 7. UI / UX (Hybrid Interface)

- Dockable panels (timeline, node graph, viewer, dope sheet, graph editor, layers)
- Toggle **"Timeline View" ↔ "Node View"** for the same content
- Viewer supports 2D + 3D camera controls
- Custom C++ render items for high-performance timeline and viewport
- Mobile: Simplified single-panel mode with gestures

### 8. Plugin & Extensibility

- **OFX**: Full host for video effects (works on motion layers too)
- **Audio Plugins**: VST3/LV2/CLAP
- **Custom Motion Nodes**: Expose C++ or QuickJS APIs for users to create new generators/behaviors
- **Frei0r**: Lightweight filters

### 9. Interoperability & Persistence

- Project format: JSON + binary + OTIO + USD scenes
- Import/Export: Premiere, Resolve, Final Cut (via OTIO), After Effects (limited via expressions)
- USD for 3D round-tripping with Blender/Houdini

### 10. Implementation Priority Order (Logical Build Sequence)

1. Core Qt + FFmpeg + ThorVG + basic player
2. Asset/Proxy system + timeline
3. Node graph + basic compositing
4. Vector shape system + keyframing
5. QuickJS expressions + procedural (Duplicators)
6. Hybrid timeline/node sync
7. Filament + USD 3D integration
8. Responsive layout engine
9. Advanced motion tools + plugins
10. Polish, mobile, export pipeline

**Dependencies** (via Conan/vcpkg):
- Qt 6.5+, FFmpeg, ThorVG, Filament, OpenUSD, QuickJS, QtNodes, OpenColorIO, OpenCV, OTIO, OpenFX, etc.


**CMake Configuration for Your Project (No Package Managers)**

Here is a clean, practical, and well-structured set of `CMakeLists.txt` files tailored for your unified **Video Editor + Motion Graphics** project, using your custom node editor.

### Recommended Project Layout

```
MotionEditor/                          # Root folder
├── CMakeLists.txt                     # Main file
├── CMakePresets.json                  # (Optional but recommended)
├── external/                          # All git cloned dependencies
│   ├── Qt-Node-editor/                # Your node editor (git submodule)
│   ├── thorvg/
│   ├── filament/
│   ├── OpenUSD/                       # or pxr USD
│   ├── quickjs/
│   ├── ffmpeg/                        # or libav sources
│   └── ... 
├── core/
├── multimedia/
├── vector/
├── three_d/
├── animation/
├── timeline/
├── nodes/
├── assets/
├── ui/
├── plugins/
├── app/
└── mobile/
```

---

### 1. Root `CMakeLists.txt`

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
    Core 
    Gui 
    Quick 
    QuickControls2 
    Widgets 
    Sql 
    Multimedia
    OpenGL
)

# ==================== Options ====================
option(ENABLE_3D "Enable Filament + USD 3D support" ON)
option(ENABLE_HIGH_END "Enable Skia instead of only ThorVG" OFF)

# ==================== Git Submodules Helper ====================
find_package(Git QUIET)
if(GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
    option(GIT_SUBMODULE "Check submodules during build" ON)
    if(GIT_SUBMODULE)
        message(STATUS "Updating git submodules...")
        execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            RESULT_VARIABLE GIT_SUBMOD_RESULT)
        if(NOT GIT_SUBMOD_RESULT EQUAL "0")
            message(FATAL_ERROR "git submodule update failed!")
        endif()
    endif()
endif()

# ==================== Add Dependencies (add_subdirectory) ====================

# Your Node Editor
add_subdirectory(external/Qt-Node-editor)

# ThorVG (Lightweight 2D Vector)
add_subdirectory(external/thorvg)

# Filament (3D) - if enabled
if(ENABLE_3D)
    add_subdirectory(external/filament)
endif()

# QuickJS
add_subdirectory(external/quickjs)

# Add more as you clone them:
# add_subdirectory(external/OpenUSD)
# add_subdirectory(external/ffmpeg)   # if you build FFmpeg from source

# ==================== Main Libraries ====================

add_subdirectory(core)
add_subdirectory(multimedia)
add_subdirectory(vector)
add_subdirectory(three_d)      # conditional
add_subdirectory(animation)
add_subdirectory(timeline)
add_subdirectory(nodes)
add_subdirectory(assets)
add_subdirectory(ui)
add_subdirectory(plugins)

# ==================== Main Application ====================
add_subdirectory(app)
```

---

### 2. `app/CMakeLists.txt` (Main Executable)

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

    # Internal libraries
    Editor::Core
    Editor::Multimedia
    Editor::Vector
    Editor::Animation
    Editor::Timeline
    Editor::Nodes
    Editor::Assets
    Editor::UI
    Editor::Plugins

    # Your Node Editor
    QtNodeEditor::NodeEditor
)

# QML Import Path
qt_add_qml_module(MotionEditorApp
    URI "MotionEditor"
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        # ... other QML files
    RESOURCES
        resources.qrc
)

target_compile_definitions(MotionEditorApp PRIVATE 
    $<$<CONFIG:Debug>:DEBUG_BUILD>
)
```

---

### 3. Example Internal Library (`nodes/CMakeLists.txt`)

```cmake
add_library(EditorNodes STATIC)

target_sources(EditorNodes PRIVATE
    NodeRegistry.cpp
    CustomNodes/ShapeGeneratorNode.cpp
    CustomNodes/DuplicatorNode.cpp
    CustomNodes/VideoSourceNode.cpp
    # ... more nodes
)

target_include_directories(EditorNodes PUBLIC 
    ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_libraries(EditorNodes PUBLIC
    Qt6::Core
    Qt6::Quick
    QtNodeEditor::NodeEditor     # Your node editor library
    Editor::Core
    Editor::Vector
    Editor::Animation
)

add_library(Editor::Nodes ALIAS EditorNodes)
```

Do the same pattern for other folders (`core`, `vector`, `timeline`, etc.).

---

### 4. `external/Qt-Node-editor` Integration

After you clone it:

```bash
cd MotionEditor
git submodule add https://github.com/Mountain-of-kings-ministry/Qt-Node-editor.git external/Qt-Node-editor
git submodule update --init --recursive
```

Then in your root `CMakeLists.txt` you already have `add_subdirectory(external/Qt-Node-editor)`.

Check the repo's own `CMakeLists.txt` — it likely defines a target like `QtNodeEditor` or similar. Link against whatever target it exports.

---

### 5. Recommended `CMakePresets.json` (Root)

```json
{
  "version": 3,
  "cmakeMinimumRequired": { "major": 3, "minor": 22, "patch": 0 },
  "configurePresets": [
    {
      "name": "debug",
      "displayName": "Debug",
      "generator": "Ninja",
      "binaryDir": "${sourceDir}/build/debug",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug",
        "ENABLE_3D": true
      }
    },
    {
      "name": "release",
      "displayName": "Release",
      "generator": "Ninja",
      "binaryDir": "${sourceDir}/build/release",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Release"
      }
    }
  ]
}
```

**Build Commands:**

```bash
cmake --preset debug
cmake --build --preset debug
```

