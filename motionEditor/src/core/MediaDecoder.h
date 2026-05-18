#pragma once
#include <QString>
#include <QImage>
#include <memory>

extern "C" {
#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
#include <libswscale/swscale.h>
#include <libavutil/imgutils.h>
}

class MediaDecoder {
public:
    explicit MediaDecoder(const QString& filePath);
    ~MediaDecoder();

    bool open();
    void close();

    std::shared_ptr<QImage> getFrame(double time);
    double duration() const { return m_duration; }

private:
    QString m_filePath;
    AVFormatContext* m_fmtCtx = nullptr;
    AVCodecContext* m_codecCtx = nullptr;
    int m_videoStreamIdx = -1;
    AVFrame* m_frame = nullptr;
    AVFrame* m_rgbFrame = nullptr;
    SwsContext* m_swsCtx = nullptr;
    uint8_t* m_buffer = nullptr;
    double m_duration = 0.0;
    double m_timeBase = 0.0;
};
