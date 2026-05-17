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


############ process chain

**Optimized Processing Chain for Tracks / Layers / Audio**  
**High Performance on Low-End Devices & Mobile**

This is a carefully designed **pull-based, lazy, multi-stage pipeline** specifically engineered for weak CPUs, limited RAM, and integrated GPUs (common on low-end laptops and mobiles).

### 1. Core Design Principles (Critical for Low-End)

- **Pull Model** (not Push): Only compute what is currently visible/requested.
- **Proxy-First**: Everything uses proxies by default.
- **Lazy Evaluation + Caching**: Heavy work is cached and reused aggressively.
- **Zero-Copy Where Possible**: Minimize data movement between CPU ↔ GPU ↔ RAM.
- **Threaded & Prioritized**: Never block UI thread. Use priority queues.
- **Partial Rendering**: Only redraw changed regions (especially important with ThorVG).
- **Early Rejection**: Skip entire tracks/layers when possible.

---

### 2. Overall Optimized Processing Chain (Frame Request → Output)

```text
User requests frame at Time T (playhead / scrub / export)
          ↓
   Output Renderer (Viewer / Final Render)
          ↓
   Timeline / Composition Resolver
          ↓
   Track / Layer Stack (Top → Bottom)
          ↓
   Per-Layer Processing Chain (parallel where safe)
          ↓
   Audio Mixing Pass (separate thread)
          ↓
   Final Composite (GPU preferred)
          ↓
   Display / Encode
```

---

### 3. Detailed Per-Frame Processing Pipeline

#### Stage 0: Early Out & Cache Check (Fast Path)
- Check if frame T is already in **final frame cache** (LRU, ~30–60 frames).
- If yes → return immediately (very common during scrubbing/pausing).
- Check per-layer cache.

#### Stage 1: Timeline / Layer Resolver (Main Thread - Very Light)
For each active track (bottom to top):

1. **Visibility & Time Range Test**
   - Is layer visible at time T?
   - Is layer muted / opacity = 0?
   - Early skip if outside in/out points.

2. **Get Source Node**
   - Resolve to proxy or full-res based on mode (Preview = Proxy, HQ/Export = Original).

#### Stage 2: Per-Layer Optimized Processing Chain (Worker Threads)

Each layer runs this chain **asynchronously** when possible:

```text
Source Data Request (Time T)
       ↓
1. Media Fetch (FFmpeg)
       ↓
2. Proxy / Resolution Adapter
       ↓
3. Motion / Procedural Evaluation
       ↓
4. Transform & Animation
       ↓
5. Effects Stack (GLSL preferred)
       ↓
6. Vector / 3D Render Pass
       ↓
7. Blend / Composite into layer buffer
```

**Detailed Breakdown**:

**1. Media Fetch (Highly Optimized)**
- Use dedicated **Decoder Pool** (2–4 threads on low-end).
- Hardware decoding (VAAPI / QuickSync / MediaCodec / VideoToolbox).
- **Prefetcher**: Always decode N frames ahead of playhead (adaptive based on CPU load).
- Return `SharedFrame` (reference-counted AVFrame or GPU texture).

**2. Proxy / Resolution Adapter**
- Video: Use proxy (360p–540p on low-end).
- Vector: ThorVG renders at viewport resolution only.
- 3D: Filament renders at reduced resolution + upscaling.

**3. Motion / Procedural Evaluation** (Critical for Motion Graphics)
- Run **QuickJS Expressions** first (very fast).
- Then Behaviors / Duplicators (generate instances procedurally).
- Use **ozz-animation** for skeletal if needed.
- Cache procedural results per frame.

**4. Transform & Animation**
- Apply position, scale, rotation, anchor (SIMD accelerated if CPU fallback).
- Use relative anchoring for responsive design.

**5. Effects Stack**
- Prefer **GLSL shaders** combined into minimal passes via Qt RHI.
- CPU fallback: ThorVG filters or Blend2D.
- Process only **Region of Interest (ROI)** when possible.

**6. Vector / 3D Render Pass**
- **2D Shapes**: ThorVG → partial redraw (huge win on low-end).
- **3D**: Filament → offscreen render target at reduced res.
- Composite 3D → 2D layers using depth or alpha.

**7. Layer Output**
- Store result in per-layer cache (key = Time + Hash of parameters).

---

### 4. Audio Processing Chain (Separate & Optimized)

Audio must stay **decoupled** from video for performance:

1. **Dedicated Audio Thread** (high priority).
2. Decode audio in chunks (1024–4096 samples) using FFmpeg.
3. Apply per-clip audio nodes (gain, EQ, effects) — use VST3/LV2 only when needed.
4. Mix all active audio tracks (SIMD-optimized mixing loop).
5. Optional: Real-time waveform analysis for reactive animation (cached).
6. Output to Qt Multimedia or PortAudio.

**Optimization**: Audio processing runs **ahead** of video (buffer 200–500ms) to avoid glitches.

---

### 5. Final Composite Stage

- Use **Qt RHI** (Vulkan/Metal/D3D/OpenGL ES) for final blending.
- Order: Bottom-to-top track compositing with blend modes.
- GPU texture upload only when necessary (prefer texture sharing).
- ThorVG smart partial update for vector-heavy scenes.

---

### 6. Caching Strategy (Most Important for Low-End)

| Cache Type              | Scope           | Size Limit       | Invalidation Trigger         |
|-------------------------|-----------------|------------------|------------------------------|
| Final Frame Cache       | Viewer          | 60 frames        | Any timeline change          |
| Per-Layer Cache         | Each Layer      | 120 frames       | Parameter / clip change      |
| Decoded Frame Cache     | FFmpeg          | 90 frames        | Seek beyond range            |
| Procedural Result Cache | Duplicators etc.| Unlimited (time) | Data source change           |
| Shader Program Cache    | GPU             | All used         | Shader source change         |

Use `std::unordered_map` + `std::shared_ptr` + weak pointers + LRU eviction.

---

### 7. Threading & Priority Model

- **Priority Queue** for frame requests:
  1. Current visible frame (Highest)
  2. Prefetch ± N frames
  3. Background proxy generation (Lowest)
  4. Export jobs

- Use `QThreadPool` with dynamic thread count (detect CPU cores, leave 1–2 free).
- On mobile/low-end: Max 2–3 decoder threads + aggressive throttling.

---

### 8. Low-End & Mobile Specific Optimizations

- Force proxy mode on devices with < 8GB RAM or weak GPU.
- Dynamic resolution scaling based on measured FPS.
- Disable 3D / complex nodes automatically when FPS drops.
- Use 8-bit proxies instead of 10-bit.
- ThorVG everywhere (Skia only if user explicitly enables "High Quality").
- Memory-mapped files for large media.

---

### 9. Implementation Skeleton (Key Classes)

```cpp
class FrameRequest {
    double time;
    QRect roi;           // Region of Interest
    bool useProxy = true;
    int qualityLevel = 1; // 0=lowest ... 3=full
};

class CompositionRenderer {
    SharedFrame getFrame(FrameRequest req);
};

class LayerProcessor {
    virtual SharedFrame process(FrameRequest req, SharedFrame input);
};
```

Would you like me to provide the **detailed C++ pseudocode / class structure** for the full processing chain (especially `CompositionRenderer`, `LayerProcessor`, and caching system) next?

### 1. Core Types (Shared Across the Project)

```cpp
// core/FrameTypes.h
#pragma once
#include <memory>
#include <QImage>
#include <QRect>
#include <atomic>

struct SharedFrame {
    std::shared_ptr<void> data;        // Can hold AVFrame*, QImage, GPU texture ID, etc.
    int width = 0;
    int height = 0;
    double timestamp = 0.0;
    bool isProxy = true;
    uint32_t format = 0;               // e.g. AV_PIX_FMT_RGBA

    // Reference counting + metadata
    std::atomic<int> refCount{1};
};

struct FrameRequest {
    double time = 0.0;
    QRect roi;                         // Region of Interest - very important for optimization
    bool useProxy = true;
    int qualityLevel = 1;              // 0 = lowest (mobile), 3 = full res
    bool forceHQ = false;
    uint64_t cacheKey = 0;             // Hash for fast lookup
};
```

---

### 2. Caching System (Critical for Performance)

```cpp
// core/FrameCache.h
#pragma once
#include <unordered_map>
#include <list>
#include <mutex>

class FrameCache {
public:
    void insert(uint64_t key, SharedFrame frame, size_t maxBytes = 512 * 1024 * 1024);
    SharedFrame get(uint64_t key);
    void invalidate(uint64_t key);
    void clear();

private:
    std::unordered_map<uint64_t, std::pair<SharedFrame, std::list<uint64_t>::iterator>> cache;
    std::list<uint64_t> lruOrder;
    size_t currentBytes = 0;
    mutable std::mutex mutex;
};
```

---

### 3. Main Processing Classes

#### **CompositionRenderer** (The Heart of the Engine)

```cpp
// core/CompositionRenderer.h
class CompositionRenderer {
public:
    explicit CompositionRenderer(QObject* parent = nullptr);

    // Main public API
    SharedFrame getFrame(const FrameRequest& request);

    // Called when user changes timeline, nodes, parameters, etc.
    void invalidateCache();

private:
    SharedFrame renderComposition(const FrameRequest& req);
    
    // Main optimized chain
    SharedFrame processTrackStack(const FrameRequest& req);
    
    FrameCache finalCache;
    FrameCache layerCache;
    
    // Thread pool for parallel layer processing
    QThreadPool* threadPool;
};
```

#### **LayerProcessor** (Base Class)

```cpp
// core/LayerProcessor.h
class LayerProcessor : public QObject {
    Q_OBJECT

public:
    virtual SharedFrame process(const FrameRequest& request, SharedFrame input = {}) = 0;

    virtual uint64_t getCacheKey(const FrameRequest& req) const;

    void setEnabled(bool enabled) { m_enabled = enabled; }
    bool isEnabled() const { return m_enabled; }

protected:
    bool m_enabled = true;
    FrameCache m_localCache;
};
```

---

### 4. Concrete Layer Processors (Examples)

#### Video Layer Processor

```cpp
// multimedia/VideoLayerProcessor.h
class VideoLayerProcessor : public LayerProcessor {
public:
    SharedFrame process(const FrameRequest& req, SharedFrame input) override;

private:
    MediaDecoder* decoder = nullptr;     // FFmpeg wrapper
    QString sourcePath;
    QString proxyPath;
};
```

#### Shape / Motion Graphics Layer (ThorVG)

```cpp
// vector/ShapeLayerProcessor.h
class ShapeLayerProcessor : public LayerProcessor {
public:
    SharedFrame process(const FrameRequest& req, SharedFrame input) override;

private:
    // Your node graph subtree for this layer
    NodeGraph* shapeGraph = nullptr;
    
    // ThorVG context
    Tvg::Canvas* canvas = nullptr;
    
    // Procedural + expressions evaluated here
    QuickJSContext* jsContext = nullptr;
};
```

#### 3D Layer Processor

```cpp
// three_d/USD3DLayerProcessor.h
class USD3DLayerProcessor : public LayerProcessor {
public:
    SharedFrame process(const FrameRequest& req, SharedFrame input) override;

private:
    FilamentEngine* filament = nullptr;
    USDStage* usdStage = nullptr;
};
```

---

### 5. Full Optimized Processing Chain Implementation

```cpp
// core/CompositionRenderer.cpp
SharedFrame CompositionRenderer::getFrame(const FrameRequest& request)
{
    // Stage 0: Fast final cache lookup
    if (auto cached = finalCache.get(request.cacheKey)) {
        return cached;
    }

    FrameRequest optimizedReq = request;
    optimizedReq.useProxy = !request.forceHQ;   // Respect proxy policy

    SharedFrame result = renderComposition(optimizedReq);

    finalCache.insert(request.cacheKey, result);
    return result;
}

SharedFrame CompositionRenderer::renderComposition(const FrameRequest& req)
{
    // Stage 1: Process all tracks bottom → top
    SharedFrame composite = processTrackStack(req);

    // Stage 2: Final post-processing (color correction, vignette, etc.)
    // composite = applyGlobalEffects(composite, req);

    return composite;
}

SharedFrame CompositionRenderer::processTrackStack(const FrameRequest& req)
{
    SharedFrame current = nullptr;   // Start with empty (transparent) frame

    for (auto& track : m_tracks) {   // from bottom to top
        if (!track->isVisibleAt(req.time)) continue;

        for (auto& layer : track->layers) {
            if (!layer->isEnabled()) continue;

            FrameRequest layerReq = req;
            layerReq.roi = calculateLayerROI(layer, req);   // Big optimization

            SharedFrame layerOutput = layer->processor->process(layerReq, current);

            // Blend onto current composite
            current = blendLayers(current, layerOutput, layer->blendMode, layer->opacity);
        }
    }

    return current;
}
```

---

### 6. Example Layer `process()` Implementation (Shape Layer)

```cpp
SharedFrame ShapeLayerProcessor::process(const FrameRequest& req, SharedFrame input)
{
    uint64_t key = getCacheKey(req);
    
    if (auto cached = m_localCache.get(key)) {
        return cached;
    }

    // 1. Evaluate procedural nodes + expressions
    evaluateNodeGraph(req.time);          // Your Qt-Node-editor graph

    // 2. Render with ThorVG (partial update)
    tvg::Canvas* canvas = getThorVGCanvas(req.width, req.height);
    renderShapesToCanvas(canvas);         // Only changed elements if possible

    // 3. Convert to SharedFrame
    SharedFrame result = createSharedFrameFromThorVG(canvas, req);

    m_localCache.insert(key, result);
    return result;
}
```

---

### 7. Audio Processing Chain (Decoupled)

```cpp
// audio/AudioMixer.h
class AudioMixer {
public:
    AudioBuffer getAudioChunk(double startTime, int samples);

private:
    std::vector<AudioClipProcessor*> activeClips;
    // SIMD mixing loop here
};
```

**Audio runs on its own high-priority thread**, staying ahead of video by 300–500ms.

---

### 8. Key Optimizations Summary (Already Built In)

- **ROI (Region of Interest)** — Only render what’s visible.
- **Per-layer + Final caching** with LRU.
- **Proxy by default** + dynamic quality.
- **Early visibility rejection**.
- **ThorVG partial rendering**.
- **Thread pool** for parallel layer processing (limit threads on low-end).
- **Hardware decoding** + prefetcher.
- **Lazy node evaluation** through your node editor.

---

Would you like me to expand any specific part with more code?

For example:
1. Full `MediaDecoder` + Prefetcher implementation
2. `blendLayers()` function with SIMD
3. Cache key generation (hashing)
4. Integration with your specific **Qt-Node-editor**
5. Dynamic quality scaler based on FPS

Just tell me which one you want next.


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
