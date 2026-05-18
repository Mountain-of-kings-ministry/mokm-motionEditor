#pragma once
#include <QObject>
#include <QQmlListProperty>
#include <vector>
#include "Layer.h"
#include "FrameTypes.h"

class Composition : public QObject {
    Q_OBJECT
    Q_PROPERTY(double duration READ duration WRITE setDuration NOTIFY durationChanged)
    Q_PROPERTY(int width READ width WRITE setWidth NOTIFY widthChanged)
    Q_PROPERTY(int height READ height WRITE setHeight NOTIFY heightChanged)
    Q_PROPERTY(double frameRate READ frameRate WRITE setFrameRate NOTIFY frameRateChanged)
    Q_PROPERTY(QQmlListProperty<Layer> layers READ qmlLayers NOTIFY layersChanged)

public:
    explicit Composition(QObject* parent = nullptr) : QObject(parent) {}

    double duration() const { return m_duration; }
    void setDuration(double d) { if (m_duration != d) { m_duration = d; emit durationChanged(); } }

    int width() const { return m_width; }
    void setWidth(int w) { if (m_width != w) { m_width = w; emit widthChanged(); } }

    int height() const { return m_height; }
    void setHeight(int h) { if (m_height != h) { m_height = h; emit heightChanged(); } }

    double frameRate() const { return m_frameRate; }
    void setFrameRate(double f) { if (m_frameRate != f) { m_frameRate = f; emit frameRateChanged(); } }

    void addLayer(Layer* layer) {
        layer->setParent(this);
        m_layers.push_back(layer);
        emit layersChanged();
    }

    QQmlListProperty<Layer> qmlLayers();
    static void appendLayer(QQmlListProperty<Layer>*, Layer*);
    static qsizetype countLayers(QQmlListProperty<Layer>*);
    static Layer* layerAt(QQmlListProperty<Layer>*, qsizetype);
    static void clearLayers(QQmlListProperty<Layer>*);

    const std::vector<Layer*>& layers() const { return m_layers; }

    Q_INVOKABLE Layer* createLayer(const QString& name);
    Q_INVOKABLE void removeLayer(Layer* layer);
    Q_INVOKABLE void moveLayer(Layer* layer, int delta);
    Q_INVOKABLE Track* createTrack(Layer* layer, TrackType type, const QString& name);
    Q_INVOKABLE VideoClip* createVideoClip(Track* track, const QString& name, const QString& path, double startTime, double duration);
    Q_INVOKABLE ThorVGClip* createThorVGClip(Track* track, const QString& name, const QString& source, double startTime, double duration);

    SharedFrame getFrame(const FrameRequest& req);

signals:
    void durationChanged();
    void widthChanged();
    void heightChanged();
    void frameRateChanged();
    void layersChanged();

private:
    double m_duration = 30.0;
    int m_width = 1920;
    int m_height = 1080;
    double m_frameRate = 29.97;
    std::vector<Layer*> m_layers;
};
