#pragma once

#include <QObject>
#include <QVariantMap>
#include "model/Settings.h"

/**
 * @brief 明暗主题 + 色板暴露给 QML
 *
 * 主题切换：
 * - isDark: 当前是否为暗色模式
 * - palette: 完整色板（QML 通过此属性获取所有颜色定义）
 * - toggle(): 切换明暗主题
 */
class ThemeViewModel : public QObject {
    Q_OBJECT

    Q_PROPERTY(bool isDark READ isDark NOTIFY isDarkChanged)
    Q_PROPERTY(QVariantMap palette READ palette NOTIFY paletteChanged)

public:
    explicit ThemeViewModel(Settings *settings, QObject *parent = nullptr);

    bool isDark() const { return m_isDark; }
    QVariantMap palette() const { return m_palette; }

    /** QML 调用：切换明暗主题 */
    Q_INVOKABLE void toggle();

signals:
    void isDarkChanged();
    void paletteChanged();

private:
    void updatePalette();

    Settings *m_settings = nullptr;
    bool m_isDark = true;
    QVariantMap m_palette;
};
