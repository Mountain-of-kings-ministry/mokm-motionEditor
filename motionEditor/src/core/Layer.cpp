#include "Layer.h"

QQmlListProperty<Track> Layer::qmlTracks() {
    return QQmlListProperty<Track>(this, nullptr,
        &Layer::appendTrack,
        &Layer::countTracks,
        &Layer::trackAt,
        &Layer::clearTracks);
}

void Layer::appendTrack(QQmlListProperty<Track>* list, Track* track) {
    auto* layer = qobject_cast<Layer*>(list->object);
    if (layer && track) {
        layer->addTrack(track);
    }
}

qsizetype Layer::countTracks(QQmlListProperty<Track>* list) {
    auto* layer = qobject_cast<Layer*>(list->object);
    return layer ? layer->m_tracks.size() : 0;
}

Track* Layer::trackAt(QQmlListProperty<Track>* list, qsizetype index) {
    auto* layer = qobject_cast<Layer*>(list->object);
    return layer ? layer->m_tracks.at(index) : nullptr;
}

void Layer::clearTracks(QQmlListProperty<Track>* list) {
    auto* layer = qobject_cast<Layer*>(list->object);
    if (layer) {
        layer->m_tracks.clear();
        emit layer->tracksChanged();
    }
}
