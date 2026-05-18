#include "MediaDecoder.h"
#include <QDebug>

MediaDecoder::MediaDecoder(const QString& filePath)
    : m_filePath(filePath)
{
}

MediaDecoder::~MediaDecoder() {
    close();
}

bool MediaDecoder::open() {
    if (avformat_open_input(&m_fmtCtx, m_filePath.toUtf8().constData(), nullptr, nullptr) < 0) {
        return false;
    }

    if (avformat_find_stream_info(m_fmtCtx, nullptr) < 0) {
        return false;
    }

    m_videoStreamIdx = av_find_best_stream(m_fmtCtx, AVMEDIA_TYPE_VIDEO, -1, -1, nullptr, 0);
    if (m_videoStreamIdx < 0) {
        return false;
    }

    AVStream* stream = m_fmtCtx->streams[m_videoStreamIdx];
    const AVCodec* codec = avcodec_find_decoder(stream->codecpar->codec_id);
    if (!codec) return false;

    m_codecCtx = avcodec_alloc_context3(codec);
    avcodec_parameters_to_context(m_codecCtx, stream->codecpar);

    if (avcodec_open2(m_codecCtx, codec, nullptr) < 0) {
        return false;
    }

    m_frame = av_frame_alloc();
    m_rgbFrame = av_frame_alloc();
    m_duration = (double)m_fmtCtx->duration / AV_TIME_BASE;
    m_timeBase = av_q2d(stream->time_base);

    return true;
}

void MediaDecoder::close() {
    if (m_swsCtx) { sws_freeContext(m_swsCtx); m_swsCtx = nullptr; }
    if (m_buffer) { av_free(m_buffer); m_buffer = nullptr; }
    if (m_rgbFrame) { av_frame_free(&m_rgbFrame); m_rgbFrame = nullptr; }
    if (m_frame) { av_frame_free(&m_frame); m_frame = nullptr; }
    if (m_codecCtx) { avcodec_free_context(&m_codecCtx); m_codecCtx = nullptr; }
    if (m_fmtCtx) { avformat_close_input(&m_fmtCtx); m_fmtCtx = nullptr; }
}

std::shared_ptr<QImage> MediaDecoder::getFrame(double time) {
    if (!m_fmtCtx || m_videoStreamIdx < 0) return nullptr;

    int64_t timestamp = time / m_timeBase;
    av_seek_frame(m_fmtCtx, m_videoStreamIdx, timestamp, AVSEEK_FLAG_BACKWARD);
    avcodec_flush_buffers(m_codecCtx);

    AVPacket pkt;
    while (av_read_frame(m_fmtCtx, &pkt) >= 0) {
        if (pkt.stream_index == m_videoStreamIdx) {
            if (avcodec_send_packet(m_codecCtx, &pkt) == 0) {
                if (avcodec_receive_frame(m_codecCtx, m_frame) == 0) {
                    double frameTime = m_frame->pts * m_timeBase;
                    if (frameTime >= time - 0.1) { // Close enough
                        // Convert to RGB
                        if (!m_swsCtx) {
                            m_swsCtx = sws_getContext(m_codecCtx->width, m_codecCtx->height, m_codecCtx->pix_fmt,
                                                    m_codecCtx->width, m_codecCtx->height, AV_PIX_FMT_RGB32,
                                                    SWS_BILINEAR, nullptr, nullptr, nullptr);
                            int numBytes = av_image_get_buffer_size(AV_PIX_FMT_RGB32, m_codecCtx->width, m_codecCtx->height, 1);
                            m_buffer = (uint8_t*)av_malloc(numBytes * sizeof(uint8_t));
                            av_image_fill_arrays(m_rgbFrame->data, m_rgbFrame->linesize, m_buffer, AV_PIX_FMT_RGB32, m_codecCtx->width, m_codecCtx->height, 1);
                        }

                        sws_scale(m_swsCtx, m_frame->data, m_frame->linesize, 0, m_codecCtx->height, m_rgbFrame->data, m_rgbFrame->linesize);

                        auto img = std::make_shared<QImage>(m_codecCtx->width, m_codecCtx->height, QImage::Format_RGB32);
                        for (int y = 0; y < m_codecCtx->height; y++) {
                            memcpy(img->scanLine(y), m_rgbFrame->data[0] + y * m_rgbFrame->linesize[0], m_codecCtx->width * 4);
                        }
                        av_packet_unref(&pkt);
                        return img;
                    }
                }
            }
        }
        av_packet_unref(&pkt);
    }
    return nullptr;
}
