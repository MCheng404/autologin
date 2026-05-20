#pragma once

#include <QString>
#include <optional>
#include <cstdint>

#ifdef Q_OS_WIN
#include "Win32Defs.h"  // DWORD, HKEY 等基本类型
#endif

namespace Platform {

/**
 * @brief 注册表读写封装 + 自启管理
 *
 * 封装 Win32 RegOpenKeyEx/RegQueryValueEx/RegSetValueEx 等操作
 * 所有方法为静态方法
 */
class Registry {
public:
    /** 读取 REG_DWORD 值，失败返回 std::nullopt */
    static std::optional<DWORD> readDword(const QString &key, const QString &value);

    /** 写入 REG_DWORD 值 */
    static void writeDword(const QString &key, const QString &value, DWORD data);

    /** 读取 REG_SZ 值，失败返回 std::nullopt */
    static std::optional<QString> readString(const QString &key, const QString &value);

    /** 写入 REG_SZ 值 */
    static void writeString(const QString &key, const QString &value, const QString &data);

    /** 删除指定注册表值 */
    static void deleteValue(const QString &key, const QString &value);

    /** 设置/取消开机自启 */
    static void setAutostart(bool enable);

    /** 检查开机自启是否启用 */
    static bool isAutostartEnabled();
};

} // namespace Platform
