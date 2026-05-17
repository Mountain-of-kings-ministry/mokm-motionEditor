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
