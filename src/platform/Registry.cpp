#include "Registry.h"

#ifdef Q_OS_WIN
// winreg.h 依赖 windows.h 提供的宏（WINADVAPI 等），不能单独使用
#include <windows.h>
#include <winreg.h>
#endif

namespace Platform {

std::optional<DWORD> Registry::readDword(const QString &key, const QString &value)
{
#ifdef Q_OS_WIN
    HKEY hKey = nullptr;
    if (RegOpenKeyExA(HKEY_CURRENT_USER, key.toUtf8().constData(),
                      0, KEY_READ, &hKey) != ERROR_SUCCESS) {
        return std::nullopt;
    }

    DWORD data = 0;
    DWORD size = sizeof(DWORD);
    LRESULT result = RegQueryValueExA(hKey, value.toUtf8().constData(),
                                       nullptr, nullptr,
                                       reinterpret_cast<LPBYTE>(&data), &size);
    RegCloseKey(hKey);

    if (result != ERROR_SUCCESS) return std::nullopt;
    return data;
#else
    return std::nullopt;
#endif
}

void Registry::writeDword(const QString &key, const QString &value, DWORD data)
{
#ifdef Q_OS_WIN
    HKEY hKey = nullptr;
    if (RegCreateKeyExA(HKEY_CURRENT_USER, key.toUtf8().constData(),
                        0, nullptr, 0, KEY_SET_VALUE, nullptr, &hKey, nullptr) != ERROR_SUCCESS) {
        return;
    }
    RegSetValueExA(hKey, value.toUtf8().constData(), 0, REG_DWORD,
                   reinterpret_cast<const BYTE*>(&data), sizeof(data));
    RegCloseKey(hKey);
#endif
}

std::optional<QString> Registry::readString(const QString &key, const QString &value)
{
#ifdef Q_OS_WIN
    HKEY hKey = nullptr;
    if (RegOpenKeyExA(HKEY_CURRENT_USER, key.toUtf8().constData(),
                      0, KEY_READ, &hKey) != ERROR_SUCCESS) {
        return std::nullopt;
    }

    DWORD size = 0;
    if (RegQueryValueExA(hKey, value.toUtf8().constData(),
                         nullptr, nullptr, nullptr, &size) != ERROR_SUCCESS) {
        RegCloseKey(hKey);
        return std::nullopt;
    }

    QByteArray buf(static_cast<int>(size), '\0');
    if (RegQueryValueExA(hKey, value.toUtf8().constData(),
                         nullptr, nullptr,
                         reinterpret_cast<LPBYTE>(buf.data()), &size) != ERROR_SUCCESS) {
        RegCloseKey(hKey);
        return std::nullopt;
    }

    RegCloseKey(hKey);
    return QString::fromUtf8(buf.constData());
#else
    return std::nullopt;
#endif
}

void Registry::writeString(const QString &key, const QString &value, const QString &data)
{
#ifdef Q_OS_WIN
    HKEY hKey = nullptr;
    if (RegCreateKeyExA(HKEY_CURRENT_USER, key.toUtf8().constData(),
                        0, nullptr, 0, KEY_SET_VALUE, nullptr, &hKey, nullptr) != ERROR_SUCCESS) {
        return;
    }
    QByteArray utf8 = data.toUtf8();
    // 包含 null terminator
    RegSetValueExA(hKey, value.toUtf8().constData(), 0, REG_SZ,
                   reinterpret_cast<const BYTE*>(utf8.constData()),
                   static_cast<DWORD>(utf8.size() + 1));
    RegCloseKey(hKey);
#endif
}

void Registry::deleteValue(const QString &key, const QString &value)
{
#ifdef Q_OS_WIN
    HKEY hKey = nullptr;
    if (RegOpenKeyExA(HKEY_CURRENT_USER, key.toUtf8().constData(),
                      0, KEY_SET_VALUE, &hKey) != ERROR_SUCCESS) {
        return;
    }
    RegDeleteValueA(hKey, value.toUtf8().constData());
    RegCloseKey(hKey);
#endif
}

void Registry::setAutostart(bool enable)
{
#ifdef Q_OS_WIN
    const QString runKey = QStringLiteral("Software\\Microsoft\\Windows\\CurrentVersion\\Run");
    if (enable) {
        char path[MAX_PATH] = {};
        GetModuleFileNameA(nullptr, path, MAX_PATH);
        writeString(runKey, QStringLiteral("AutoLogin"), QString::fromUtf8(path));
    } else {
        deleteValue(runKey, QStringLiteral("AutoLogin"));
    }
#endif
}

bool Registry::isAutostartEnabled()
{
#ifdef Q_OS_WIN
    const QString runKey = QStringLiteral("Software\\Microsoft\\Windows\\CurrentVersion\\Run");
    return readString(runKey, QStringLiteral("AutoLogin")).has_value();
#else
    return false;
#endif
}

} // namespace Platform
