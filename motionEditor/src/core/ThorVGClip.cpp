#include "ThorVGClip.h"
#include <QImage>
#include <QPainter>
#include <QFont>
#include <thorvg.h>

SharedFrame ThorVGClip::render(const FrameRequest& req) {
    SharedFrame frame;
    frame.timestamp = req.time;

    QSize size = req.roi.isValid() ? req.roi.size() : QSize(1280, 720);

    // Initialize ThorVG
    static bool tvgInit = false;
    if (!tvgInit) {
        tvg::Initializer::init(tvg::CanvasEngine::Sw, 0);
        tvgInit = true;
    }

    auto canvas = tvg::SwCanvas::gen();
    auto buffer = std::make_shared<QImage>(size, QImage::Format_ARGB32_Premultiplied);
    buffer->fill(Qt::transparent);

    canvas->target((uint32_t*)buffer->bits(), size.width(), size.width(), size.height(), tvg::SwCanvas::ARGB8888);

    auto picture = tvg::Picture::gen();
    // Remove "file://" prefix if present
    QString path = m_vectorSource;
    if (path.startsWith("file://")) path = path.mid(7);

    if (path.endsWith(".svg", Qt::CaseInsensitive)) {
        if (picture->load(path.toStdString()) == tvg::Result::Success) {
            picture->size(size.width(), size.height());
            canvas->push(std::move(picture));
            canvas->draw();
            canvas->sync();
            
            frame.image = buffer;
            frame.width = size.width();
            frame.height = size.height();
            return frame;
        }
    }

    auto placeholder = std::make_shared<QImage>(size, QImage::Format_ARGB32);
    placeholder->fill(QColor(34, 197, 94, 200)); // Semi-transparent Green

    QPainter p(placeholder.get());
    p.setPen(Qt::white);
    p.setFont(QFont("Arial", 24, QFont::Bold));
    p.drawText(placeholder->rect(), Qt::AlignCenter, "Vector: " + name());
    p.end();

    frame.image = placeholder;
    frame.width = placeholder->width();
    frame.height = placeholder->height();

    return frame;
}
