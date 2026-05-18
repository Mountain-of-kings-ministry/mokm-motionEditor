#pragma once
#include "Clip.h"
#include <memory>

class MediaDecoder;

class VideoClip : public Clip {
    Q_OBJECT
    Q_PROPERTY(QString sourcePath READ sourcePath WRITE setSourcePath NOTIFY sourcePathChanged)
    Q_PROPERTY(QString proxyPath READ proxyPath WRITE setProxyPath NOTIFY proxyPathChanged)
    Q_PROPERTY(bool useProxy READ useProxy WRITE setUseProxy NOTIFY useProxyChanged)

public:
    explicit VideoClip(QObject* parent = nullptr) : Clip(parent) {}

    QString sourcePath() const { return m_sourcePath; }
    void setSourcePath(const QString& p);

    QString proxyPath() const { return m_proxyPath; }
    void setProxyPath(const QString& p) { if (m_proxyPath != p) { m_proxyPath = p; emit proxyPathChanged(); } }

    bool useProxy() const { return m_useProxy; }
    void setUseProxy(bool u) { if (m_useProxy != u) { m_useProxy = u; emit useProxyChanged(); } }

    ClipType type() const override { return ClipType::Video; }
    SharedFrame render(const FrameRequest& req) override;

signals:
    void sourcePathChanged();
    void proxyPathChanged();
    void useProxyChanged();

private:
    QString m_sourcePath;
    QString m_proxyPath;
    bool m_useProxy = true;
    std::unique_ptr<MediaDecoder> m_decoder;
};
