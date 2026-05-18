#pragma once
#include "Clip.h"

class ThorVGClip : public Clip {
    Q_OBJECT
    Q_PROPERTY(QString vectorSource READ vectorSource WRITE setVectorSource NOTIFY vectorSourceChanged)

public:
    explicit ThorVGClip(QObject* parent = nullptr) : Clip(parent) {}

    QString vectorSource() const { return m_vectorSource; }
    void setVectorSource(const QString& s) { if (m_vectorSource != s) { m_vectorSource = s; emit vectorSourceChanged(); } }

    ClipType type() const override { return ClipType::Vector; }
    SharedFrame render(const FrameRequest& req) override;

signals:
    void vectorSourceChanged();

private:
    QString m_vectorSource;
};
