#include "Scheduler.h"
#include "Settings.h"

Scheduler::Scheduler(Settings *settings, QObject *parent)
    : QObject(parent)
    , m_settings(settings)
{
}

bool Scheduler::shouldTrigger(qint64 nowSec)
{
    if (!m_settings->schedEnabled()) return false;

    qint64 next = nextTriggerTime();
    return (nowSec >= next);
}

void Scheduler::recordTrigger(qint64 ts)
{
    m_lastSchedAuth = ts;
}

qint64 Scheduler::nextTriggerTime() const
{
    qint64 intervalSec = static_cast<qint64>(m_settings->schedInterval()) * 3600;
    int offsetMin = m_settings->schedOffset();
    qint64 offsetSec = static_cast<qint64>(offsetMin) * 60;

    qint64 base = 0;
    if (m_lastSchedAuth == 0) {
        // 首次：从当前时间往前推到最近的 interval 边界
        qint64 nowSec = QDateTime::currentSecsSinceEpoch();
        qint64 period = intervalSec + offsetSec;
        if (period > 0) {
            qint64 elapsed = (nowSec % period);
            base = nowSec - elapsed;
        } else {
            base = nowSec;
        }
    } else {
        base = m_lastSchedAuth;
    }

    qint64 next = 0;
    if (offsetMin < 0) {
        // 负偏移：下次触发时间 = last + interval - |offset|
        next = base + intervalSec - static_cast<qint64>(-offsetMin) * 60;
    } else {
        next = base + intervalSec + offsetSec;
    }

    return next;
}
