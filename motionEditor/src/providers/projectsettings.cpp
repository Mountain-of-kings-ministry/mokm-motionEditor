#include "projectsettings.h"

ProjectSettings::ProjectSettings(QObject *parent)
    : QObject{parent}
{
}

QString ProjectSettings::projectName() const { return m_projectName; }
int ProjectSettings::width() const { return m_width; }
int ProjectSettings::height() const { return m_height; }
double ProjectSettings::frameRate() const { return m_frameRate; }
double ProjectSettings::pixelAspectRatio() const { return m_pixelAspectRatio; }
double ProjectSettings::duration() const { return m_duration; }
int ProjectSettings::audioSampleRate() const { return m_audioSampleRate; }
QString ProjectSettings::colorSpace() const { return m_colorSpace; }
int ProjectSettings::bitDepth() const { return m_bitDepth; }
int ProjectSettings::proxyResolution() const { return m_proxyResolution; }
bool ProjectSettings::enable3D() const { return m_enable3D; }
QString ProjectSettings::renderer() const { return m_renderer; }
QString ProjectSettings::vectorEngine() const { return m_vectorEngine; }

void ProjectSettings::setProjectName(const QString &name)
{
    if (name != m_projectName) {
        m_projectName = name;
        emit projectNameChanged();
    }
}

void ProjectSettings::setWidth(int w)
{
    if (w != m_width) {
        m_width = w;
        emit widthChanged();
    }
}

void ProjectSettings::setHeight(int h)
{
    if (h != m_height) {
        m_height = h;
        emit heightChanged();
    }
}

void ProjectSettings::setFrameRate(double fps)
{
    if (fps != m_frameRate) {
        m_frameRate = fps;
        emit frameRateChanged();
    }
}

void ProjectSettings::setPixelAspectRatio(double par)
{
    if (par != m_pixelAspectRatio) {
        m_pixelAspectRatio = par;
        emit pixelAspectRatioChanged();
    }
}

void ProjectSettings::setDuration(double secs)
{
    if (secs != m_duration) {
        m_duration = secs;
        emit durationChanged();
    }
}

void ProjectSettings::setAudioSampleRate(int rate)
{
    if (rate != m_audioSampleRate) {
        m_audioSampleRate = rate;
        emit audioSampleRateChanged();
    }
}

void ProjectSettings::setColorSpace(const QString &cs)
{
    if (cs != m_colorSpace) {
        m_colorSpace = cs;
        emit colorSpaceChanged();
    }
}

void ProjectSettings::setBitDepth(int depth)
{
    if (depth != m_bitDepth) {
        m_bitDepth = depth;
        emit bitDepthChanged();
    }
}

void ProjectSettings::setProxyResolution(int px)
{
    if (px != m_proxyResolution) {
        m_proxyResolution = px;
        emit proxyResolutionChanged();
    }
}

void ProjectSettings::setEnable3D(bool enable)
{
    if (enable != m_enable3D) {
        m_enable3D = enable;
        emit enable3DChanged();
    }
}

void ProjectSettings::setRenderer(const QString &r)
{
    if (r != m_renderer) {
        m_renderer = r;
        emit rendererChanged();
    }
}

void ProjectSettings::setVectorEngine(const QString &ve)
{
    if (ve != m_vectorEngine) {
        m_vectorEngine = ve;
        emit vectorEngineChanged();
    }
}
