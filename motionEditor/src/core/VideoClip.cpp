#include "VideoClip.h"
#include "MediaDecoder.h"
#include <QDebug>
#include <QPainter>
#include <QFont>

void VideoClip::setSourcePath(const QString& p) {
    if (m_sourcePath != p) {
        m_sourcePath = p;
        m_decoder = std::make_unique<MediaDecoder>(m_sourcePath);
        if (m_decoder->open()) {
            setDuration(m_decoder->duration());
        }
        emit sourcePathChanged();
    }
}

SharedFrame VideoClip::render(const FrameRequest& req) {
    SharedFrame frame;
    frame.timestamp = req.time;
    
    if (m_decoder) {
        double localTime = req.time - startTime();
        auto img = m_decoder->getFrame(localTime);
        if (img) {
            frame.image = img;
            frame.width = img->width();
            frame.height = img->height();
            return frame;
        }
    }
    
    QSize size = req.roi.isValid() ? req.roi.size() : QSize(1280, 720);
    auto placeholder = std::make_shared<QImage>(size, QImage::Format_ARGB32);
    placeholder->fill(QColor(59, 130, 246, 200)); // Semi-transparent Blue
    
    QPainter p(placeholder.get());
    p.setPen(Qt::white);
    p.setFont(QFont("Arial", 24, QFont::Bold));
    p.drawText(placeholder->rect(), Qt::AlignCenter, "Video: " + name());
    p.end();

    frame.image = placeholder;
    frame.width = placeholder->width();
    frame.height = placeholder->height();
    
    return frame;
}
