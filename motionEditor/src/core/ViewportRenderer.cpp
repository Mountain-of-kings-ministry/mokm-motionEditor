#include "ViewportRenderer.h"
#include <QSGSimpleTextureNode>
#include <QQuickWindow>

ViewportRenderer::ViewportRenderer(QQuickItem* parent)
    : QQuickItem(parent)
{
    setFlag(ItemHasContents, true);
}

void ViewportRenderer::setComposition(Composition* c) {
    if (m_composition != c) {
        m_composition = c;
        emit compositionChanged();
        update();
    }
}

void ViewportRenderer::setCurrentTime(double t) {
    if (!qFuzzyCompare(m_currentTime, t)) {
        m_currentTime = t;
        emit currentTimeChanged();
        update();
    }
}

QSGNode* ViewportRenderer::updatePaintNode(QSGNode* oldNode, UpdatePaintNodeData*) {
    if (!m_composition) return nullptr;

    QSGSimpleTextureNode* node = static_cast<QSGSimpleTextureNode*>(oldNode);
    if (!node) {
        node = new QSGSimpleTextureNode();
    }

    FrameRequest req;
    req.time = m_currentTime;
    req.roi = QRect(0, 0, width(), height());
    
    SharedFrame frame = m_composition->getFrame(req);
    if (frame.image && !frame.image->isNull()) {
        QSGTexture* texture = window()->createTextureFromImage(*frame.image);
        node->setOwnsTexture(true);
        node->setTexture(texture);
        node->setRect(boundingRect());
    }

    return node;
}
