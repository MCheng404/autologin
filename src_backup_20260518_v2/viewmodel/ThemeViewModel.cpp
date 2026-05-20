#include "ThemeViewModel.h"

#include <QGuiApplication>
#include <QStyleHints>

ThemeViewModel::ThemeViewModel(Settings *settings, QObject *parent)
    : QObject(parent)
    , m_settings(settings)
    , m_themeMode(settings->theme())
    , m_systemIsDark(detectSystemDark())
{
    refreshIsDark();
    updatePalette();

    // 监听 Settings 的 theme 变化（由 QML 或外部修改）
    connect(m_settings, &Settings::themeChanged, this, [this]() {
        int mode = m_settings->theme();
        if (m_themeMode != mode) {
            m_themeMode = mode;
            refreshIsDark();
            updatePalette();
            emit themeModeChanged();
        }
    });

    // 监听系统主题变化（当 mode=System 时自动跟随）
    if (auto *hints = QGuiApplication::styleHints()) {
        connect(hints, &QStyleHints::colorSchemeChanged, this, [this]() {
            bool dark = detectSystemDark();
            if (m_systemIsDark != dark) {
                m_systemIsDark = dark;
                emit isSystemDarkChanged();
                if (m_themeMode == 2) {
                    refreshIsDark();
                    updatePalette();
                }
            }
        });
    }
}

bool ThemeViewModel::detectSystemDark()
{
    if (auto *hints = QGuiApplication::styleHints()) {
        return hints->colorScheme() == Qt::ColorScheme::Dark;
    }
    return true; // 默认暗色
}

void ThemeViewModel::refreshIsDark()
{
    bool dark;
    switch (m_themeMode) {
    case 0: dark = true; break;   // Force Dark
    case 1: dark = false; break;  // Force Light
    case 2: dark = m_systemIsDark; break; // Follow System
    default: dark = true; break;
    }

    if (m_isDark != dark) {
        m_isDark = dark;
        emit isDarkChanged();
    }
}

void ThemeViewModel::toggle()
{
    // Dark → Light → System → Dark
    int next = (m_themeMode + 1) % 3;
    setThemeMode(next);
}

void ThemeViewModel::setThemeMode(int mode)
{
    mode = qBound(0, mode, 2);
    if (m_themeMode == mode) return;

    m_themeMode = mode;
    m_settings->setTheme(mode);
    m_settings->save();

    refreshIsDark();
    updatePalette();
    emit themeModeChanged();
}

void ThemeViewModel::updatePalette()
{
    if (m_isDark) {
        m_palette = {
            {QStringLiteral("background"),       QStringLiteral("#0f0f1a")},
            {QStringLiteral("surface"),           QStringLiteral("#1a1a2e")},
            {QStringLiteral("surfaceVariant"),    QStringLiteral("#252540")},
            {QStringLiteral("primary"),            QStringLiteral("#818cf8")},
            {QStringLiteral("primaryHover"),      QStringLiteral("#6366f1")},
            {QStringLiteral("primaryContainer"),  QStringLiteral("#312e81")},
            {QStringLiteral("onPrimary"),         QStringLiteral("#ffffff")},
            {QStringLiteral("onSurface"),         QStringLiteral("#e2e8f0")},
            {QStringLiteral("onSurfaceVariant"),  QStringLiteral("#94a3b8")},
            {QStringLiteral("outline"),            QStringLiteral("#334155")},
            {QStringLiteral("outlineVariant"),     QStringLiteral("#1e293b")},
            {QStringLiteral("error"),              QStringLiteral("#f87171")},
            {QStringLiteral("success"),            QStringLiteral("#4ade80")},
            {QStringLiteral("warning"),            QStringLiteral("#fb923c")},
            {QStringLiteral("textPrimary"),        QStringLiteral("#f1f5f9")},
            {QStringLiteral("textSecondary"),      QStringLiteral("#94a3b8")},
            {QStringLiteral("textTertiary"),       QStringLiteral("#64748b")},
            {QStringLiteral("cardBackground"),     QStringLiteral("#1e1e36")},
            {QStringLiteral("cardBorder"),         QStringLiteral("#2d2d4a")},
            {QStringLiteral("toggleTrack"),        QStringLiteral("#334155")},
            {QStringLiteral("toggleActive"),       QStringLiteral("#818cf8")},
            {QStringLiteral("inputBackground"),    QStringLiteral("#16162a")},
            {QStringLiteral("inputBorder"),         QStringLiteral("#2d2d4a")},
            {QStringLiteral("inputFocusBorder"),   QStringLiteral("#818cf8")},
            {QStringLiteral("divider"),             QStringLiteral("#1e293b")},
            {QStringLiteral("hoverBackground"),    QStringLiteral("#1e293b")},
            {QStringLiteral("closeHover"),         QStringLiteral("#334155")},
            {QStringLiteral("overlay"),             QStringLiteral("#00000080")}
        };
    } else {
        m_palette = {
            {QStringLiteral("background"),       QStringLiteral("#f8fafc")},
            {QStringLiteral("surface"),           QStringLiteral("#ffffff")},
            {QStringLiteral("surfaceVariant"),    QStringLiteral("#f1f5f9")},
            {QStringLiteral("primary"),            QStringLiteral("#6366f1")},
            {QStringLiteral("primaryHover"),      QStringLiteral("#4f46e5")},
            {QStringLiteral("primaryContainer"),  QStringLiteral("#e0e7ff")},
            {QStringLiteral("onPrimary"),         QStringLiteral("#ffffff")},
            {QStringLiteral("onSurface"),         QStringLiteral("#1e293b")},
            {QStringLiteral("onSurfaceVariant"),  QStringLiteral("#64748b")},
            {QStringLiteral("outline"),            QStringLiteral("#e2e8f0")},
            {QStringLiteral("outlineVariant"),     QStringLiteral("#f1f5f9")},
            {QStringLiteral("error"),              QStringLiteral("#ef4444")},
            {QStringLiteral("success"),            QStringLiteral("#22c55e")},
            {QStringLiteral("warning"),            QStringLiteral("#f59e0b")},
            {QStringLiteral("textPrimary"),        QStringLiteral("#0f172a")},
            {QStringLiteral("textSecondary"),      QStringLiteral("#64748b")},
            {QStringLiteral("textTertiary"),       QStringLiteral("#94a3b8")},
            {QStringLiteral("cardBackground"),     QStringLiteral("#ffffff")},
            {QStringLiteral("cardBorder"),         QStringLiteral("#e2e8f0")},
            {QStringLiteral("toggleTrack"),        QStringLiteral("#cbd5e1")},
            {QStringLiteral("toggleActive"),       QStringLiteral("#6366f1")},
            {QStringLiteral("inputBackground"),    QStringLiteral("#f8fafc")},
            {QStringLiteral("inputBorder"),         QStringLiteral("#e2e8f0")},
            {QStringLiteral("inputFocusBorder"),   QStringLiteral("#6366f1")},
            {QStringLiteral("divider"),             QStringLiteral("#e2e8f0")},
            {QStringLiteral("hoverBackground"),    QStringLiteral("#f1f5f9")},
            {QStringLiteral("closeHover"),         QStringLiteral("#fee2e2")},
            {QStringLiteral("overlay"),             QStringLiteral("#00000026")}
        };
    }

    emit paletteChanged();
}
