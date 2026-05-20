#pragma once

#include <QString>

class QSystemTrayIcon;

namespace Platform {

/**
 * @brief 气泡通知（基于 QSystemTrayIcon::showMessage）
 *
 * 使用 Qt6 原生托盘通知，无需手动管理 HWND/HICON
 * 通过 setTrayIcon() 设置 QSystemTrayIcon 指针
 */
class Notification {
public:
    enum class Type {
        Info,
        Error,
        Success
    };

    /** 显示气泡通知 */
    static void show(const QString &title, const QString &msg, Type type = Type::Info);

    /** 设置通知开关 */
    static void setEnabled(bool enabled);

    /** 设置托盘图标指针（用于 showMessage） */
    static void setTrayIcon(QSystemTrayIcon *tray);

private:
    static bool             s_enabled;
    static QSystemTrayIcon *s_trayIcon;
};

} // namespace Platform
