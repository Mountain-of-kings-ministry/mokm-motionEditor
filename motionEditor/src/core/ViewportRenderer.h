#pragma once
#include <QQuickItem>
#include "Composition.h"

class ViewportRenderer : public QQuickItem {
    Q_OBJECT
    Q_PROPERTY(Composition* composition READ composition WRITE setComposition NOTIFY compositionChanged)
    Q_PROPERTY(double currentTime READ currentTime WRITE setCurrentTime NOTIFY currentTimeChanged)

public:
    explicit ViewportRenderer(QQuickItem* parent = nullptr);

    Composition* composition() const { return m_composition; }
    void setComposition(Composition* c);

    double currentTime() const { return m_currentTime; }
    void setCurrentTime(double t);

    void paint(QPainter* painter);

protected:
    QSGNode* updatePaintNode(QSGNode* oldNode, UpdatePaintNodeData*) override;

signals:
    void compositionChanged();
    void currentTimeChanged();

private:
    Composition* m_composition = nullptr;
    double m_currentTime = 0.0;
    bool m_needsUpdate = true;
};
