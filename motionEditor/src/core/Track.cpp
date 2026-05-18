#include "Track.h"

QQmlListProperty<Clip> Track::qmlClips() {
    return QQmlListProperty<Clip>(this, nullptr,
        &Track::appendClip,
        &Track::countClips,
        &Track::clipAt,
        &Track::clearClips);
}

void Track::appendClip(QQmlListProperty<Clip>* list, Clip* clip) {
    auto* track = qobject_cast<Track*>(list->object);
    if (track && clip) {
        track->addClip(clip);
    }
}

qsizetype Track::countClips(QQmlListProperty<Clip>* list) {
    auto* track = qobject_cast<Track*>(list->object);
    return track ? track->m_clips.size() : 0;
}

Clip* Track::clipAt(QQmlListProperty<Clip>* list, qsizetype index) {
    auto* track = qobject_cast<Track*>(list->object);
    return track ? track->m_clips.at(index) : nullptr;
}

void Track::clearClips(QQmlListProperty<Clip>* list) {
    auto* track = qobject_cast<Track*>(list->object);
    if (track) {
        track->m_clips.clear();
        emit track->clipsChanged();
    }
}
