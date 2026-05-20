#pragma once

#include <QString>

namespace Platform {

/**
 * @brief Toast 通知（自定义 QWindow 悬浮通知）
 *
 * 使用独立 QQuickWindow 实现右下角悬浮通知，
 * 完全不依赖系统通知 API，主题跟随，100% 可靠。
 *
 * 特性：
 * - 右下角浮现，自动 4s 后渐隐消失
 * - 点击可提前关闭
 * - 主题色跟随（info=蓝 / success=绿 / error=红）
 * - 圆角卡片风格
 */
class Notification {
public:
    enum class Type {
        Info,
        Error,
        Success
    };

    /** 显示通知 */
    static void show(const QString &title, const QString &msg, Type type = Type::Info);

    /** 设置通知开关 */
    static void setEnabled(bool enabled);

private:
    static bool s_enabled;
};

} // namespace Platform
