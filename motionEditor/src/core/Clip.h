#pragma once
#include <QObject>
#include <QPointF>
#include <QVector2D>
#include "AnimatableProperty.h"
#include "FrameTypes.h"
#include "Types.h"

class Clip : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(double startTime READ startTime WRITE setStartTime NOTIFY startTimeChanged)
    Q_PROPERTY(double duration READ duration WRITE setDuration NOTIFY durationChanged)

public:
    explicit Clip(QObject* parent = nullptr) : QObject(parent) {}
    virtual ~Clip() = default;

    QString name() const { return m_name; }
    void setName(const QString& n) { if (m_name != n) { m_name = n; emit nameChanged(); } }

    double startTime() const { return m_startTime; }
    void setStartTime(double s) { if (m_startTime != s) { m_startTime = s; emit startTimeChanged(); } }

    double duration() const { return m_duration; }
    void setDuration(double d) { if (m_duration != d) { m_duration = d; emit durationChanged(); } }

    // Common Animatable Properties
    AnimatableProperty<double> opacity{1.0};
    AnimatableProperty<QPointF> position{QPointF(0.0, 0.0)};
    AnimatableProperty<QVector2D> scale{QVector2D(1.0f, 1.0f)};
    AnimatableProperty<double> rotation{0.0};
    AnimatableProperty<QPointF> anchorPoint{QPointF(0.5, 0.5)};

    virtual ClipType type() const = 0;
    virtual SharedFrame render(const FrameRequest& req) = 0;

    bool isVisibleAt(double time) const {
        return time >= m_startTime && time <= (m_startTime + m_duration);
    }

signals:
    void nameChanged();
    void startTimeChanged();
    void durationChanged();

private:
    QString m_name;
    double m_startTime = 0.0;
    double m_duration = 0.0;
};
