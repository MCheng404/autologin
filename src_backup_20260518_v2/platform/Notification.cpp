#include "Notification.h"

#include <QSystemTrayIcon>

namespace Platform {

bool             Notification::s_enabled  = true;
QSystemTrayIcon *Notification::s_trayIcon  = nullptr;

void Notification::setEnabled(bool enabled)
{
    s_enabled = enabled;
}

void Notification::setTrayIcon(QSystemTrayIcon *tray)
{
    s_trayIcon = tray;
}

void Notification::show(const QString &title, const QString &msg, Type type)
{
    if (!s_enabled) return;
    if (!s_trayIcon) return;

    QSystemTrayIcon::MessageIcon icon = QSystemTrayIcon::Information;
    switch (type) {
    case Type::Info:
        icon = QSystemTrayIcon::Information;
        break;
    case Type::Error:
        icon = QSystemTrayIcon::Critical;
        break;
    case Type::Success:
        icon = QSystemTrayIcon::Information;
        break;
    }

    s_trayIcon->showMessage(title, msg, icon, 5000);
}

} // namespace Platform
