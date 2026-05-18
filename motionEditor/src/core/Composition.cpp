#include "Composition.h"
#include "VideoClip.h"
#include "ThorVGClip.h"
#include <QPainter>

QQmlListProperty<Layer> Composition::qmlLayers() {
    return QQmlListProperty<Layer>(this, nullptr,
        &Composition::appendLayer,
        &Composition::countLayers,
        &Composition::layerAt,
        &Composition::clearLayers);
}

void Composition::appendLayer(QQmlListProperty<Layer>* list, Layer* layer) {
    auto* comp = qobject_cast<Composition*>(list->object);
    if (comp && layer) {
        comp->addLayer(layer);
    }
}

qsizetype Composition::countLayers(QQmlListProperty<Layer>* list) {
    auto* comp = qobject_cast<Composition*>(list->object);
    return comp ? comp->m_layers.size() : 0;
}

Layer* Composition::layerAt(QQmlListProperty<Layer>* list, qsizetype index) {
    auto* comp = qobject_cast<Composition*>(list->object);
    return comp ? comp->m_layers.at(index) : nullptr;
}

void Composition::clearLayers(QQmlListProperty<Layer>* list) {
    auto* comp = qobject_cast<Composition*>(list->object);
    if (comp) {
        comp->m_layers.clear();
        emit comp->layersChanged();
    }
}

Layer* Composition::createLayer(const QString& name) {
    auto* layer = new Layer(this);
    layer->setName(name);
    addLayer(layer);
    return layer;
}

Track* Composition::createTrack(Layer* layer, TrackType type, const QString& name) {
    if (!layer) return nullptr;
    auto* track = new Track(layer);
    track->setType(type);
    track->setName(name);
    layer->addTrack(track);
    return track;
}

VideoClip* Composition::createVideoClip(Track* track, const QString& name, const QString& path, double startTime, double duration) {
    if (!track) return nullptr;
    auto* clip = new VideoClip(track);
    clip->setName(name);
    clip->setSourcePath(path);
    clip->setStartTime(startTime);
    clip->setDuration(duration);
    track->addClip(clip);
    return clip;
}

ThorVGClip* Composition::createThorVGClip(Track* track, const QString& name, const QString& source, double startTime, double duration) {
    if (!track) return nullptr;
    auto* clip = new ThorVGClip(track);
    clip->setName(name);
    clip->setVectorSource(source);
    clip->setStartTime(startTime);
    clip->setDuration(duration);
    track->addClip(clip);
    return clip;
}

SharedFrame Composition::getFrame(const FrameRequest& req) {
    // Stage 1: Create final output buffer
    auto resultImage = std::make_shared<QImage>(m_width, m_height, QImage::Format_ARGB32_Premultiplied);
    resultImage->fill(Qt::transparent);

    QPainter painter(resultImage.get());
    painter.setRenderHint(QPainter::Antialiasing);

    // Stage 2: Process all layers bottom -> top (index based)
    // In our vector, index 0 is at the bottom.
    for (auto* layer : m_layers) {
        if (!layer->enabled()) continue;

        // Stage 3: Process all tracks inside layer bottom -> top
        for (auto* track : layer->tracks()) {
            if (!track->enabled() || track->muted()) continue;

            // Stage 4: Find and render clips active at req.time
            for (auto* clip : track->clips()) {
                if (clip->isVisibleAt(req.time)) {
                    SharedFrame clipFrame = clip->render(req);
                    if (clipFrame.image) {
                        // TODO: Apply clip transforms and blend modes
                        // For now, just draw at top-left
                        painter.drawImage(0, 0, *clipFrame.image);
                    }
                }
            }
        }
    }

    painter.end();

    SharedFrame finalFrame;
    finalFrame.image = resultImage;
    finalFrame.width = m_width;
    finalFrame.height = m_height;
    finalFrame.timestamp = req.time;
    finalFrame.isProxy = req.useProxy;

    return finalFrame;
}
