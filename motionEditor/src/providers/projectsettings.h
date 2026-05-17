#ifndef PROJECTSETTINGS_H
#define PROJECTSETTINGS_H

#include <QObject>
#include <QString>

class ProjectSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString projectName READ projectName WRITE setProjectName NOTIFY projectNameChanged FINAL)
    Q_PROPERTY(int width READ width WRITE setWidth NOTIFY widthChanged FINAL)
    Q_PROPERTY(int height READ height WRITE setHeight NOTIFY heightChanged FINAL)
    Q_PROPERTY(double frameRate READ frameRate WRITE setFrameRate NOTIFY frameRateChanged FINAL)
    Q_PROPERTY(double pixelAspectRatio READ pixelAspectRatio WRITE setPixelAspectRatio NOTIFY pixelAspectRatioChanged FINAL)
    Q_PROPERTY(double duration READ duration WRITE setDuration NOTIFY durationChanged FINAL)
    Q_PROPERTY(int audioSampleRate READ audioSampleRate WRITE setAudioSampleRate NOTIFY audioSampleRateChanged FINAL)
    Q_PROPERTY(QString colorSpace READ colorSpace WRITE setColorSpace NOTIFY colorSpaceChanged FINAL)
    Q_PROPERTY(int bitDepth READ bitDepth WRITE setBitDepth NOTIFY bitDepthChanged FINAL)
    Q_PROPERTY(int proxyResolution READ proxyResolution WRITE setProxyResolution NOTIFY proxyResolutionChanged FINAL)
    Q_PROPERTY(bool enable3D READ enable3D WRITE setEnable3D NOTIFY enable3DChanged FINAL)
    Q_PROPERTY(QString renderer READ renderer WRITE setRenderer NOTIFY rendererChanged FINAL)
    Q_PROPERTY(QString vectorEngine READ vectorEngine WRITE setVectorEngine NOTIFY vectorEngineChanged FINAL)

public:
    explicit ProjectSettings(QObject *parent = nullptr);

    QString projectName() const;
    int width() const;
    int height() const;
    double frameRate() const;
    double pixelAspectRatio() const;
    double duration() const;
    int audioSampleRate() const;
    QString colorSpace() const;
    int bitDepth() const;
    int proxyResolution() const;
    bool enable3D() const;
    QString renderer() const;
    QString vectorEngine() const;

public slots:
    void setProjectName(const QString &name);
    void setWidth(int w);
    void setHeight(int h);
    void setFrameRate(double fps);
    void setPixelAspectRatio(double par);
    void setDuration(double secs);
    void setAudioSampleRate(int rate);
    void setColorSpace(const QString &cs);
    void setBitDepth(int depth);
    void setProxyResolution(int px);
    void setEnable3D(bool enable);
    void setRenderer(const QString &r);
    void setVectorEngine(const QString &ve);

signals:
    void projectNameChanged();
    void widthChanged();
    void heightChanged();
    void frameRateChanged();
    void pixelAspectRatioChanged();
    void durationChanged();
    void audioSampleRateChanged();
    void colorSpaceChanged();
    void bitDepthChanged();
    void proxyResolutionChanged();
    void enable3DChanged();
    void rendererChanged();
    void vectorEngineChanged();

private:
    QString m_projectName = "Untitled";
    int m_width = 1920;
    int m_height = 1080;
    double m_frameRate = 29.97;
    double m_pixelAspectRatio = 1.0;
    double m_duration = 30.0;
    int m_audioSampleRate = 48000;
    QString m_colorSpace = "Rec.709";
    int m_bitDepth = 8;
    int m_proxyResolution = 0;
    bool m_enable3D = true;
    QString m_renderer = "Auto";
    QString m_vectorEngine = "ThorVG (Default)";
};

#endif // PROJECTSETTINGS_H
