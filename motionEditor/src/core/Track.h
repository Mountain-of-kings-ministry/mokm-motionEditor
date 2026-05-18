#pragma once
#include <QObject>
#include <QQmlListProperty>
#include <vector>
#include <memory>
#include "Clip.h"
#include "Types.h"

class Track : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(TrackType type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(bool muted READ muted WRITE setMuted NOTIFY mutedChanged)
    Q_PROPERTY(bool solo READ solo WRITE setSolo NOTIFY soloChanged)
    Q_PROPERTY(QQmlListProperty<Clip> clips READ qmlClips NOTIFY clipsChanged)

public:
    explicit Track(QObject* parent = nullptr) : QObject(parent) {}

    QString name() const { return m_name; }
    void setName(const QString& n) { if (m_name != n) { m_name = n; emit nameChanged(); } }

    TrackType type() const { return m_type; }
    void setType(TrackType t) { if (m_type != t) { m_type = t; emit typeChanged(); } }

    bool enabled() const { return m_enabled; }
    void setEnabled(bool e) { if (m_enabled != e) { m_enabled = e; emit enabledChanged(); } }

    bool muted() const { return m_muted; }
    void setMuted(bool m) { if (m_muted != m) { m_muted = m; emit mutedChanged(); } }

    bool solo() const { return m_solo; }
    void setSolo(bool s) { if (m_solo != s) { m_solo = s; emit soloChanged(); } }

    void addClip(Clip* clip) {
        clip->setParent(this);
        m_clips.push_back(clip);
        emit clipsChanged();
    }

    QQmlListProperty<Clip> qmlClips();
    static void appendClip(QQmlListProperty<Clip>*, Clip*);
    static qsizetype countClips(QQmlListProperty<Clip>*);
    static Clip* clipAt(QQmlListProperty<Clip>*, qsizetype);
    static void clearClips(QQmlListProperty<Clip>*);

    const std::vector<Clip*>& clips() const { return m_clips; }

signals:
    void nameChanged();
    void typeChanged();
    void enabledChanged();
    void mutedChanged();
    void soloChanged();
    void clipsChanged();

private:
    QString m_name;
    TrackType m_type = TrackType::Video;
    bool m_enabled = true;
    bool m_muted = false;
    bool m_solo = false;
    std::vector<Clip*> m_clips;
};
