Clean build, clean run. Here's what was built:

### New Files

| File | Purpose |
|---|---|
| `fragments/TrackTypeConfig.qml` | Static `QtObject` with `ListModel` of 5 track types + `iconFor()`, `colorFor()`, `labelFor()` helpers |
| `fragments/AddTrackDialog.qml` | `Popup` with 3×2 grid of colored type cards, Cancel + Add Track buttons |
| `timeline/TimelineLayerHeader.qml` | Layer header bar (name, eye icon, lock icon), right-click `Menu`: Add Track, Lock, Visibility, Move Up/Down, Delete |
| `timeline/TimelineTrackHeader.qml` | Track header with colored 3px left strip (per type), type icon, name, right-click `Menu`: Lock, Visibility, Move Up/Down, Delete |

### Track Type Visual Identity

| Type | Color | Icon |
|---|---|---|
| Video | `#3b82f6` blue | `video.svg` |
| Audio | `#22c55e` green | `music.svg` |
| Vector | `#a855f7` purple | `git-merge.svg` |
| Text | `#f59e0b` amber | `text-caption.svg` |
| Mask | `#ef4444` red | `mask.svg` |

### TimelineTab Rewrite
- **On startup**: creates 1 default Layer ("Layer 1") with 1 Video Track
- **Left panel** (200px): scrollable list of layer/track headers — layers collapsible, tracks indented 12px
- **Right panel**: track lanes area with 24px time ruler at top
- **Bottom**: `[+ Layer]` button
- **Selection**: clicking a header sets `selectedLayer` / `selectedTrack` → automatically flows to PropertiesPanel

### PropertiesPanel Updates
- `selectedLayer` / `selectedTrack` properties bound directly to TimelineTab
- Layer section: Opacity, Blend, Position X/Y, Scale X/Y, Rotation — all read/write from the JS object
- Track section: Muted, Solo, Opacity, Volume — synced bidirectionally
- Fixed all deprecation warnings (`newText`, `val` parameter injection → `function()`)
