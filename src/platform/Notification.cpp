#include "Notification.h"
#include "ToastWindow.h"
#include "Registry.h"

namespace Platform {

bool Notification::s_enabled = true;

void Notification::show(const QString &title, const QString &msg, Type type)
{
    if (!s_enabled) return;

    QString typeStr;
    switch (type) {
    case Type::Error:   typeStr = "error";   break;
    case Type::Success: typeStr = "success"; break;
    case Type::Info:
    default:            typeStr = "info";    break;
    }

    // 读取通知位置设置（0=右下, 1=左下, 2=顶部居中）
    int toastPosition = 0;
    auto pos = Registry::readDword(QStringLiteral("Software\\AutoLogin\\Settings"),
                                   QStringLiteral("ToastPosition"));
    if (pos.has_value()) {
        toastPosition = qBound(0, static_cast<int>(pos.value()), 2);
    }

    // 获取主窗口作为 transient parent（让 toast 悬浮在主窗口上方）
    QWindow *parent = nullptr;
    const auto wins = QGuiApplication::allWindows();
    for (QWindow *w : wins) {
        if (w->isVisible() && !w->title().isEmpty()) {
            parent = w;
            break;
        }
    }

    ToastWindow::show(title, msg, typeStr, toastPosition, parent);
}

void Notification::setEnabled(bool enabled)
{
    s_enabled = enabled;
}

} // namespace Platform
