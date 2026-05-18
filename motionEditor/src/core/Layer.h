#pragma once
#include <QObject>
#include <QQmlListProperty>
#include <vector>
#include <QRectF>
#include "Track.h"
#include "Types.h"

class Layer : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(bool locked READ locked WRITE setLocked NOTIFY lockedChanged)
    Q_PROPERTY(QQmlListProperty<Track> tracks READ qmlTracks NOTIFY tracksChanged)

public:
    explicit Layer(QObject* parent = nullptr) : QObject(parent) {}

    QString name() const { return m_name; }
    void setName(const QString& n) { if (m_name != n) { m_name = n; emit nameChanged(); } }

    bool enabled() const { return m_enabled; }
    void setEnabled(bool e) { if (m_enabled != e) { m_enabled = e; emit enabledChanged(); } }

    bool locked() const { return m_locked; }
    void setLocked(bool l) { if (m_locked != l) { m_locked = l; emit lockedChanged(); } }

    // Layer-level properties
    AnimatableProperty<double> opacity{1.0};
    AnimatableProperty<BlendMode> blendMode{BlendMode::Normal};
    AnimatableProperty<QRectF> cropRect;

    void addTrack(Track* track) {
        track->setParent(this);
        m_tracks.push_back(track);
        emit tracksChanged();
    }

    Q_INVOKABLE void removeTrack(Track* track);
    Q_INVOKABLE void moveTrack(Track* track, int delta);

    QQmlListProperty<Track> qmlTracks();
    static void appendTrack(QQmlListProperty<Track>*, Track*);
    static qsizetype countTracks(QQmlListProperty<Track>*);
    static Track* trackAt(QQmlListProperty<Track>*, qsizetype);
    static void clearTracks(QQmlListProperty<Track>*);

    const std::vector<Track*>& tracks() const { return m_tracks; }

signals:
    void nameChanged();
    void enabledChanged();
    void lockedChanged();
    void tracksChanged();

private:
    QString m_name;
    bool m_enabled = true;
    bool m_locked = false;
    std::vector<Track*> m_tracks;
};
