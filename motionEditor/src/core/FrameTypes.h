#pragma once
#include <memory>
#include <QImage>
#include <QRect>

struct SharedFrame {
    std::shared_ptr<QImage> image;     // CPU-based rendering initial implementation
    int width = 0;
    int height = 0;
    double timestamp = 0.0;
    bool isProxy = true;
};

struct FrameRequest {
    double time = 0.0;
    QRect roi;
    bool useProxy = true;
    int qualityLevel = 1;
    uint64_t cacheKey = 0;
};
