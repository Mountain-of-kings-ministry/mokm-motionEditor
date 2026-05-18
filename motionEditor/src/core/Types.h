#pragma once
#include <QString>
#include <QObject>

class Types {
    Q_GADGET
public:
    enum class BlendMode {
        Normal, Add, Multiply, Screen, Overlay, Lighten, Darken
    };
    Q_ENUM(BlendMode)

    enum class TrackType {
        Video, Audio, Vector, Text, Subtitle, Mask
    };
    Q_ENUM(TrackType)

    enum class ClipType {
        Video, Audio, Vector, Text, Image, USD3D
    };
    Q_ENUM(ClipType)
};

using BlendMode = Types::BlendMode;
using TrackType = Types::TrackType;
using ClipType = Types::ClipType;
