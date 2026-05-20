#pragma once

#include <QObject>
#include <QDateTime>

class Settings;

/**
 * @brief 定时认证调度器（间隔 + 偏移）
 *
 * 计算定时认证的触发时间：
 * - 间隔：每 N 小时触发一次
 * - 偏移：±30 分钟随机偏移，避免大量设备同时认证
 */
class Scheduler : public QObject {
    Q_OBJECT

public:
    explicit Scheduler(Settings *settings, QObject *parent = nullptr);

    /** 判断当前时间是否应该触发定时认证 */
    bool shouldTrigger(qint64 nowSec);

    /** 记录本次触发时间 */
    void recordTrigger(qint64 ts);

    /** 计算下次触发时间戳（秒） */
    qint64 nextTriggerTime() const;

signals:
    /** 触发认证信号 */
    void triggerAuth();

private:
    qint64 m_lastSchedAuth{0};
    Settings *m_settings = nullptr;
};
