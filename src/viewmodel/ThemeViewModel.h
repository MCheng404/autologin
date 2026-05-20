#pragma once

#include <QObject>
#include <QVariantMap>
#include "model/Settings.h"

/**
 * @brief 明暗主题 + 色板暴露给 QML
 *
 * 主题模式：
 * - 0 = Dark（强制暗色）
 * - 1 = Light（强制亮色）
 * - 2 = System（跟随系统，默认）
 *
 * 属性：
 * - isDark: 当前实际是否暗色（考虑 system 模式后）
 * - themeMode: 当前模式 0/1/2
 * - palette: 完整色板
 * - isSystemDark: 系统当前是否暗色
 *
 * QML 接口：
 * - toggle(): 循环切换 Dark→Light→System→Dark
 * - setThemeMode(int): 设置指定模式
 */
class ThemeViewModel : public QObject {
    Q_OBJECT

    Q_PROPERTY(bool isDark READ isDark NOTIFY isDarkChanged)
    Q_PROPERTY(int themeMode READ themeMode NOTIFY themeModeChanged)
    Q_PROPERTY(QVariantMap palette READ palette NOTIFY paletteChanged)
    Q_PROPERTY(bool isSystemDark READ isSystemDark NOTIFY isSystemDarkChanged)
    Q_PROPERTY(int accentColorIndex READ accentColorIndex WRITE setAccentColorIndex NOTIFY accentColorIndexChanged)
    Q_PROPERTY(QVariantList accentColors READ accentColors CONSTANT)

public:
    explicit ThemeViewModel(Settings *settings, QObject *parent = nullptr);

    bool isDark() const { return m_isDark; }
    int themeMode() const { return m_themeMode; }
    QVariantMap palette() const { return m_palette; }
    bool isSystemDark() const { return m_systemIsDark; }

    /** QML 调用：循环切换 Dark→Light→System */
    Q_INVOKABLE void toggle();

    /** QML 调用：设置指定模式 (0=Dark, 1=Light, 2=System) */
    Q_INVOKABLE void setThemeMode(int mode);

    int accentColorIndex() const { return m_accentColorIndex; }
    void setAccentColorIndex(int index);
    QVariantList accentColors() const { return m_accentColors; }

signals:
    void isDarkChanged();
    void themeModeChanged();
    void paletteChanged();
    void isSystemDarkChanged();
    void accentColorIndexChanged();

private:
    void updatePalette();
    void refreshIsDark();
    static bool detectSystemDark();

    Settings *m_settings = nullptr;
    int m_themeMode = 2;        // 0=Dark, 1=Light, 2=System
    bool m_systemIsDark = true;  // 系统当前暗色状态
    bool m_isDark = true;        // 最终暗色状态（考虑 system 模式）
    QVariantMap m_palette;
    int m_accentColorIndex = 0;  // 主题色索引 0-15
    QVariantList m_accentColors; // 16 种主题色列表
};
