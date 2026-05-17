**✅ Comprehensive Compositing System Draft**

Here's a clean, professional, and performant architecture tailored for your project.

### 1. Overall Hierarchy (Compositing Model)

```
Composition (Root)
   └── Layer (List of Layers - stacked bottom to top)
         ├── Properties (Opacity, Blend Mode, Transform, Effects...)
         └── Track (Multiple tracks per layer)
               ├── Properties (Mute, Solo, Volume, Pan...)
               └── Clip / Strip (Video, Audio, Text, Vector, Image, 3D...)
                     ├── Properties (Position, Scale, Rotation, Opacity...)
                     ├── Start/End Time
                     └── Node Graph (for procedural/effects)
```

This design gives you **flexibility** while keeping it efficient for low-end devices.

---

### 2. Core Classes

#### **Composition** (Top Level)

```cpp
class Composition {
    double duration = 300.0;           // in seconds
    int width = 1920;
    int height = 1080;
    double frameRate = 60.0;

    std::vector<std::unique_ptr<Layer>> layers;
    
    // Global settings
    ColorManagementSettings colorMgmt;
    
    SharedFrame getFrame(const FrameRequest& req);
};
```

---

#### **Layer** (Main Compositing Unit)

```cpp
class Layer {
public:
    QString name;
    bool enabled = true;
    bool locked = false;

    // Animatable Properties
    AnimatableProperty<double> opacity{1.0};
    AnimatableProperty<BlendMode> blendMode{BlendMode::Normal};
    AnimatableProperty<Transform2D> transform;        // position, scale, rotation, anchor
    AnimatableProperty<QRectF> cropRect;

    // Effects Stack (applied after all tracks are composited)
    std::vector<std::unique_ptr<EffectNode>> effects;

    // Tracks inside this layer
    std::vector<std::unique_ptr<Track>> tracks;

    // Audio Routing
    QString audioBusName = "Master";     // Which bus this layer sends audio to

    SharedFrame compositeLayer(const FrameRequest& req);   // Main rendering function
};
```

---

#### **Track** (Inside Layer)

```cpp
class Track {
public:
    QString name;
    TrackType type;           // Video, Audio, Text, Vector, Subtitle, etc.

    bool muted = false;
    bool solo = false;

    // Common Animatable Properties
    AnimatableProperty<double> opacity{1.0};
    AnimatableProperty<BlendMode> blendMode{BlendMode::Normal};

    // Audio Specific
    AnimatableProperty<double> volume{1.0};      // 0.0 - 2.0
    AnimatableProperty<double> pan{0.0};         // -1.0 (left) to 1.0 (right)

    std::vector<std::unique_ptr<Clip>> clips;

    // For Audio Tracks → sends to Layer's audioBus
};
```

---

#### **Clip / Strip** (Base + Derived Types)

```cpp
class Clip {
public:
    QString name;
    double startTime = 0.0;      // in seconds (timeline position)
    double duration = 10.0;

    // Core Animatable Properties (most used)
    AnimatableProperty<QPointF> position{0, 0};
    AnimatableProperty<QVector2D> scale{1.0, 1.0};
    AnimatableProperty<double> rotation{0.0};
    AnimatableProperty<double> opacity{1.0};
    AnimatableProperty<QPointF> anchorPoint{0.5, 0.5};   // normalized 0-1

    // Node Graph for procedural motion & effects
    NodeGraph* nodeGraph = nullptr;     // Your Qt-Node-editor graph

    virtual SharedFrame render(const FrameRequest& req) = 0;
    virtual AudioBuffer renderAudio(double start, int samples) = 0;
};
```

**Derived Clip Types:**

- `VideoClip` → uses FFmpeg + proxy
- `VectorClip` / `ThorVGClip` → uses ThorVG renderer
- `TextClip` → text + ThorVG or Qt text rendering
- `ImageClip`
- `AudioClip`
- `USD3DClip` (future)

---

### 3. Animatable Property System (Recommended)

```cpp
template<typename T>
class AnimatableProperty {
public:
    T value;                                    // Current value (when no keyframes)
    std::vector<Keyframe<T>> keyframes;

    T evaluate(double time) const;              // Returns interpolated value
    void setValue(T v, double time);            // Creates keyframe or sets static
};
```

---

### 4. Rendering / Compositing Flow (Optimized)

```cpp
SharedFrame Layer::compositeLayer(const FrameRequest& req)
{
    SharedFrame result = nullptr;

    // 1. Composite all tracks bottom → top
    for (auto& track : tracks) {
        if (track->muted) continue;

        SharedFrame trackOutput = nullptr;

        for (auto& clip : track->clips) {
            if (!clip->isVisibleAt(req.time)) continue;

            SharedFrame clipFrame = clip->render(req);

            trackOutput = blend(trackOutput, clipFrame, clip->opacity.evaluate(req.time));
        }

        // Apply track-level properties
        result = blend(result, trackOutput, track->opacity.evaluate(req.time));
    }

    // 2. Apply Layer-level Effects
    for (auto& effect : effects) {
        result = effect->apply(result, req);
    }

    // 3. Apply Layer Transform + Opacity
    result = applyTransformAndOpacity(result, transform.evaluate(req.time), opacity.evaluate(req.time));

    return result;
}
```

---

### 5. Audio Routing System

```cpp
// In Layer
void Layer::routeAudio(AudioMixer& mixer, double time, int samples)
{
    AudioBuffer layerBuffer;

    for (auto& track : tracks) {
        if (track->type != TrackType::Audio || track->muted) continue;

        AudioBuffer trackBuffer;

        for (auto& clip : track->clips) {
            if (clip->isVisibleAt(time)) {
                trackBuffer = mix(trackBuffer, clip->renderAudio(time, samples));
            }
        }

        // Apply track volume/pan
        trackBuffer = applyGainAndPan(trackBuffer, track->volume, track->pan);
        layerBuffer = mix(layerBuffer, trackBuffer);
    }

    // Send to Bus
    mixer.sendToBus(audioBusName, layerBuffer);
}
```

**Audio Engine Structure Suggestion**:
- `AudioMixer` → has multiple `AudioBus`
- Each `AudioBus` can have effects (EQ, Compressor, Reverb, etc.)
- Master Bus is the final output

---

### 6. ThorVG Integration Strategy

- `ThorVGClip` renders using ThorVG engine.
- Can be used inside **Vector Tracks** or mixed with video tracks.
- You can have a dedicated **Vector Layer** that only uses ThorVG for maximum performance.

in simple terms
layers holds tracks -> and tracks can either be a vector/audio/video/text which will contain their strips/clips

**✅ Detailed Properties Specification**

Here's a clean, well-organized, and professional breakdown of properties for **Layer → Track → Strip/Clip**, with clear differentiation by type.

---

### 1. Layer Properties

A **Layer** is the top-level container (like a composition/group). Effects applied here affect everything inside.

| Property | Type | Animatable | Description | Applies To |
|---------|------|----------|-----------|----------|
| `name` | QString | No | Layer name | All |
| `enabled` | bool | No | Toggle layer visibility | All |
| `locked` | bool | No | Prevent editing | All |
| `opacity` | double (0.0–1.0) | Yes | Global opacity | All |
| `blendMode` | BlendMode enum | Yes | Normal, Add, Multiply, Screen, Overlay, etc. | All |
| `transform` | Transform2D | Yes | Position, Scale, Rotation, Anchor, Skew | All |
| `cropRect` | QRectF | Yes | Crop the entire layer output | All |
| `audioBusName` | QString | No | Which audio bus this layer sends to | All (Audio relevant) |
| `effects` | List<EffectNode> | - | Post-processing effects (Color Correction, Blur, etc.) | All |
| `visible` | bool | Yes | Master visibility (can be keyframed) | All |

---

### 2. Track Properties

A **Track** lives inside a Layer. Multiple tracks per layer (for stacking).

| Property | Type | Animatable | Description | Applies To |
|---------|------|----------|-----------|----------|
| `name` | QString | No | Track name | All |
| `type` | TrackType enum | No | Video, Audio, Vector, Text, Subtitle | All |
| `enabled` | bool | No | Enable/disable track | All |
| `muted` | bool | No | Mute track | All |
| `solo` | bool | No | Solo track | All |
| `opacity` | double (0–1) | Yes | Track-level opacity | Video, Vector, Text |
| `blendMode` | BlendMode | Yes | Blending with tracks below | Video, Vector, Text |
| `volume` | double (0.0–2.0+) | Yes | Track volume | Audio |
| `pan` | double (-1.0 to 1.0) | Yes | Stereo panning | Audio |
| `clips` | List<Clip> | - | Clips/Strips on this track | All |

---

### 3. Strip / Clip Properties (By Type)

#### **Base Clip Properties** (Common to All)

| Property | Type | Animatable | Description |
|---------|------|----------|-----------|
| `name` | QString | No | Clip name |
| `startTime` | double | No | Position on timeline (seconds) |
| `duration` | double | No | Length of clip |
| `inPoint` / `outPoint` | double | No | Trim points (media time) |
| `opacity` | double | Yes | Clip opacity |
| `position` | QPointF | Yes | Position (X, Y) |
| `scale` | QVector2D | Yes | Scale (X, Y) |
| `rotation` | double | Yes | Rotation in degrees |
| `anchorPoint` | QPointF | Yes | Anchor (0.0–1.0 normalized) |
| `nodeGraph` | NodeGraph* | - | Your Qt-Node-editor graph for procedural animation |

---

#### **A. Video Clip Properties**

| Property | Type | Animatable | Description |
|---------|------|----------|-----------|
| `sourcePath` | QString | No | Original video file |
| `proxyPath` | QString | No | Proxy file path |
| `useProxy` | bool | No | Force proxy usage |
| `speed` | double | Yes | Speed ramp (1.0 = normal) |
| `reverse` | bool | No | Play backwards |
| `deinterlace` | bool | No | Deinterlacing option |
| `colorSpace` | ColorSpace | Yes | Input color space |
| `videoEffects` | List<EffectNode> | - | Per-clip video effects |

---

#### **B. Vector / ThorVG Clip Properties**

| Property | Type | Animatable | Description |
|---------|------|----------|-----------|
| `vectorSource` | QString or QByteArray | No | SVG / Lottie / ThorVG scene data |
| `rendererType` | enum (ThorVG, Skia) | No | Which renderer to use |
| `renderQuality` | int (0–100) | Yes | Quality level |
| `cacheEnabled` | bool | No | Enable frame caching |
| `vectorEffects` | List<EffectNode> | - | Vector-specific effects |
| `lottieTimeRemap` | double | Yes | For Lottie animations |

---

#### **C. Audio Clip Properties**

| Property | Type | Animatable | Description |
|---------|------|----------|-----------|
| `audioSourcePath` | QString | No | Audio file path |
| `volume` | double | Yes | Clip volume |
| `pan` | double | Yes | Clip pan |
| `fadeInDuration` | double | Yes | Fade in time |
| `fadeOutDuration` | double | Yes | Fade out time |
| `audioEffects` | List<AudioEffect> | - | VST3 / LV2 / built-in effects |
| `waveformCache` | QByteArray | No | Cached waveform for UI |

---

#### **D. Text Clip Properties**

| Property | Type | Animatable | Description |
|---------|------|----------|-----------|
| `text` | QString | Yes | Text content |
| `fontFamily` | QString | Yes | Font name |
| `fontSize` | double | Yes | Font size |
| `fontColor` | QColor | Yes | Text color |
| `fontStyle` | enum | Yes | Bold, Italic, etc. |
| `alignment` | enum | Yes | Left, Center, Right |
| `outlineEnabled` | bool | Yes | Text outline |
| `outlineColor` | QColor | Yes | Outline color |
| `outlineWidth` | double | Yes | Outline thickness |
| `shadowEnabled` | bool | Yes | Drop shadow |
| `shadowOffset` | QPointF | Yes | Shadow position |
| `shadowBlur` | double | Yes | Shadow blur radius |
| `textEffects` | List<EffectNode> | - | Advanced text effects |

---

### Recommended Implementation Tip

```cpp
// Example structure
class Clip {
    // Base properties (common)
    AnimatableProperty<double> opacity;
    AnimatableProperty<QPointF> position;
    // ...
    
    // Type-specific
    std::variant<VideoClipData, VectorClipData, AudioClipData, TextClipData> typeData;
};
```

---

the composition will ba based on index layer 1 will be ontop of layer two ......
track 1 will be ontop of track 2 ........


**✅ Here are the full C++ class definitions** for your compositing system.

### 1. Common Header (`core/Types.h`)

```cpp
#pragma once
#include <QPointF>
#include <QVector2D>
#include <QColor>
#include <QString>
#include <memory>
#include <vector>
#include <variant>

enum class BlendMode {
    Normal, Add, Multiply, Screen, Overlay, Lighten, Darken
};

enum class TrackType {
    Video, Audio, Vector, Text, Subtitle, Mask
};

enum class ClipType {
    Video, Audio, Vector, Text, Image, USD3D
};
```

---

### 2. Animatable Property (`core/AnimatableProperty.h`)

```cpp
#pragma once
#include <vector>

template<typename T>
struct Keyframe {
    double time = 0.0;
    T value;
    // TODO: Add easing/interpolation type later
};

template<typename T>
class AnimatableProperty {
public:
    T staticValue;
    std::vector<Keyframe<T>> keyframes;

    AnimatableProperty(T defaultValue = T{}) : staticValue(defaultValue) {}

    T evaluate(double time) const;
    void setStatic(T value) { staticValue = value; keyframes.clear(); }
    void setKeyframe(double time, T value);
};
```

---

### 3. Base Clip (`core/Clip.h`)

```cpp
#pragma once
#include "AnimatableProperty.h"
#include "FrameTypes.h"
#include "../nodes/NodeGraph.h"

class Clip {
public:
    virtual ~Clip() = default;

    QString name;
    double startTime = 0.0;      // Timeline position (seconds)
    double duration = 0.0;
    double inPoint = 0.0;        // Trim in
    double outPoint = 0.0;       // Trim out

    // Common Animatable Properties
    AnimatableProperty<double> opacity{1.0};
    AnimatableProperty<QPointF> position{0.0, 0.0};
    AnimatableProperty<QVector2D> scale{1.0f, 1.0f};
    AnimatableProperty<double> rotation{0.0};
    AnimatableProperty<QPointF> anchorPoint{0.5, 0.5};   // Normalized 0.0-1.0

    // Node Graph for procedural animation / effects
    std::unique_ptr<NodeGraph> nodeGraph;

    virtual ClipType getType() const = 0;
    virtual SharedFrame render(const FrameRequest& req) = 0;
    virtual AudioBuffer renderAudio(double time, int samples) = 0;

    bool isVisibleAt(double time) const;
};
```

---

### 4. Specific Clip Types

#### **VideoClip**

```cpp
// core/VideoClip.h
#pragma once
#include "Clip.h"

class VideoClip : public Clip {
public:
    ClipType getType() const override { return ClipType::Video; }

    QString sourcePath;
    QString proxyPath;
    bool useProxy = true;

    AnimatableProperty<double> speed{1.0};
    bool reverse = false;

    SharedFrame render(const FrameRequest& req) override;
    AudioBuffer renderAudio(double time, int samples) override;

private:
    MediaDecoder* decoder = nullptr;   // FFmpeg wrapper
};
```

#### **Vector / ThorVG Clip**

```cpp
// vector/ThorVGClip.h
#pragma once
#include "Clip.h"
#include <thorvg.h>

class ThorVGClip : public Clip {
public:
    ClipType getType() const override { return ClipType::Vector; }

    QString vectorSource;           // SVG, Lottie, or serialized ThorVG data
    bool useThorVG = true;

    AnimatableProperty<int> renderQuality{80};

    SharedFrame render(const FrameRequest& req) override;
    AudioBuffer renderAudio(double time, int samples) override { return {}; }

private:
    std::unique_ptr<tvg::Canvas> canvas;
    tvg::Scene* scene = nullptr;
};
```

#### **Text Clip**

```cpp
// vector/TextClip.h
#pragma once
#include "Clip.h"

class TextClip : public Clip {
public:
    ClipType getType() const override { return ClipType::Text; }

    AnimatableProperty<QString> text{"Sample Text"};
    AnimatableProperty<QString> fontFamily{"Arial"};
    AnimatableProperty<double> fontSize{48.0};
    AnimatableProperty<QColor> fontColor{Qt::white};

    AnimatableProperty<bool> outlineEnabled{false};
    AnimatableProperty<QColor> outlineColor{Qt::black};
    AnimatableProperty<double> outlineWidth{2.0};

    AnimatableProperty<bool> shadowEnabled{false};
    AnimatableProperty<QPointF> shadowOffset{2.0, 2.0};
    AnimatableProperty<double> shadowBlur{4.0};

    SharedFrame render(const FrameRequest& req) override;
    AudioBuffer renderAudio(double time, int samples) override { return {}; }
};
```

#### **Audio Clip**

```cpp
// audio/AudioClip.h
#pragma once
#include "Clip.h"

class AudioClip : public Clip {
public:
    ClipType getType() const override { return ClipType::Audio; }

    QString audioSourcePath;

    AnimatableProperty<double> volume{1.0};
    AnimatableProperty<double> pan{0.0};

    AnimatableProperty<double> fadeIn{0.0};
    AnimatableProperty<double> fadeOut{0.0};

    SharedFrame render(const FrameRequest& req) override { return {}; }  // No visual
    AudioBuffer renderAudio(double time, int samples) override;

private:
    AudioDecoder* audioDecoder = nullptr;
};
```

---

### 5. Track Class (`core/Track.h`)

```cpp
#pragma once
#include "Clip.h"

class Track {
public:
    QString name;
    TrackType type = TrackType::Video;
    bool enabled = true;
    bool muted = false;
    bool solo = false;

    // Common properties
    AnimatableProperty<double> opacity{1.0};
    AnimatableProperty<BlendMode> blendMode{BlendMode::Normal};

    // Audio specific
    AnimatableProperty<double> volume{1.0};
    AnimatableProperty<double> pan{0.0};

    std::vector<std::unique_ptr<Clip>> clips;

    bool isAudioTrack() const { return type == TrackType::Audio; }
};
```

---

### 6. Layer Class (`core/Layer.h`)

```cpp
#pragma once
#include "Track.h"
#include "EffectNode.h"

class Layer {
public:
    QString name;
    bool enabled = true;
    bool locked = false;

    // Layer-level properties
    AnimatableProperty<double> opacity{1.0};
    AnimatableProperty<BlendMode> blendMode{BlendMode::Normal};
    AnimatableProperty<Transform2D> transform;   // Position, Scale, Rotation, etc.
    AnimatableProperty<QRectF> cropRect;

    // Effects applied to the entire layer after all tracks are composited
    std::vector<std::unique_ptr<EffectNode>> effects;

    // Tracks inside this layer
    std::vector<std::unique_ptr<Track>> tracks;

    // Audio Routing
    QString audioBusName = "Master";

    SharedFrame composite(const FrameRequest& req);     // Main render function
    void processAudio(AudioMixer& mixer, double time, int samples);

    Track* addTrack(TrackType type, const QString& name);
};
```

---

These classes are designed to be:
- Clean and extensible
- High performance (minimal virtual calls where possible)
- Ready for your Qt-Node-editor integration
- Compatible with ThorVG and FFmpeg
