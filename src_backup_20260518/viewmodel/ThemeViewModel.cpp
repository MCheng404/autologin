#include "ThemeViewModel.h"

ThemeViewModel::ThemeViewModel(Settings *settings, QObject *parent)
    : QObject(parent)
    , m_settings(settings)
{
    m_isDark = (m_settings->theme() == 0);
    updatePalette();

    connect(m_settings, &Settings::themeChanged, this, [this]() {
        bool dark = (m_settings->theme() == 0);
        if (m_isDark != dark) {
            m_isDark = dark;
            updatePalette();
            emit isDarkChanged();
        }
    });
}

void ThemeViewModel::toggle()
{
    m_isDark = !m_isDark;
    m_settings->setTheme(m_isDark ? 0 : 1);
    m_settings->save();
    updatePalette();
    emit isDarkChanged();
}

void ThemeViewModel::updatePalette()
{
    if (m_isDark) {
        m_palette = {
            {QStringLiteral("background"),       QStringLiteral("#1a1a2e")},
            {QStringLiteral("surface"),           QStringLiteral("#1e1e32")},
            {QStringLiteral("surfaceVariant"),    QStringLiteral("#252540")},
            {QStringLiteral("primary"),            QStringLiteral("#6366f1")},
            {QStringLiteral("primaryContainer"),  QStringLiteral("#8b5cf6")},
            {QStringLiteral("onSurface"),         QStringLiteral("#e0e0e0")},
            {QStringLiteral("onSurfaceVariant"),  QStringLiteral("#a0a0b0")},
            {QStringLiteral("outline"),            QStringLiteral("#3a3a5c")},
            {QStringLiteral("outlineVariant"),     QStringLiteral("#2a2a48")},
            {QStringLiteral("error"),              QStringLiteral("#ef4444")},
            {QStringLiteral("success"),            QStringLiteral("#4ade80")},
            {QStringLiteral("warning"),            QStringLiteral("#fb923c")},
            {QStringLiteral("textPrimary"),        QStringLiteral("#ffffff")},
            {QStringLiteral("textSecondary"),      QStringLiteral("rgba(255,255,255,0.45)")},
            {QStringLiteral("textTertiary"),       QStringLiteral("rgba(255,255,255,0.3)")},
            {QStringLiteral("cardBackground"),     QStringLiteral("rgba(30,30,50,0.75)")},
            {QStringLiteral("cardBorder"),         QStringLiteral("rgba(255,255,255,0.08)")},
            {QStringLiteral("toggleTrack"),        QStringLiteral("rgba(255,255,255,0.15)")},
            {QStringLiteral("toggleActive"),       QStringLiteral("#6366f1")},
            {QStringLiteral("inputBackground"),    QStringLiteral("rgba(255,255,255,0.04)")},
            {QStringLiteral("inputBorder"),         QStringLiteral("rgba(255,255,255,0.08)")},
            {QStringLiteral("overlay"),             QStringLiteral("rgba(0,0,0,0.5)")}
        };
    } else {
        m_palette = {
            {QStringLiteral("background"),       QStringLiteral("#f5f5fa")},
            {QStringLiteral("surface"),           QStringLiteral("#ffffff")},
            {QStringLiteral("surfaceVariant"),    QStringLiteral("#f0f0f5")},
            {QStringLiteral("primary"),            QStringLiteral("#6366f1")},
            {QStringLiteral("primaryContainer"),  QStringLiteral("#8b5cf6")},
            {QStringLiteral("onSurface"),         QStringLiteral("#1a1a2e")},
            {QStringLiteral("onSurfaceVariant"),  QStringLiteral("#666680")},
            {QStringLiteral("outline"),            QStringLiteral("#d0d0e0")},
            {QStringLiteral("outlineVariant"),     QStringLiteral("#e0e0f0")},
            {QStringLiteral("error"),              QStringLiteral("#ef4444")},
            {QStringLiteral("success"),            QStringLiteral("#22c55e")},
            {QStringLiteral("warning"),            QStringLiteral("#f59e0b")},
            {QStringLiteral("textPrimary"),        QStringLiteral("#1a1a2e")},
            {QStringLiteral("textSecondary"),      QStringLiteral("rgba(0,0,0,0.5)")},
            {QStringLiteral("textTertiary"),       QStringLiteral("rgba(0,0,0,0.35)")},
            {QStringLiteral("cardBackground"),     QStringLiteral("rgba(255,255,255,0.85)")},
            {QStringLiteral("cardBorder"),         QStringLiteral("rgba(0,0,0,0.06)")},
            {QStringLiteral("toggleTrack"),        QStringLiteral("rgba(0,0,0,0.15)")},
            {QStringLiteral("toggleActive"),       QStringLiteral("#6366f1")},
            {QStringLiteral("inputBackground"),    QStringLiteral("rgba(0,0,0,0.03)")},
            {QStringLiteral("inputBorder"),         QStringLiteral("rgba(0,0,0,0.08)")},
            {QStringLiteral("overlay"),             QStringLiteral("rgba(0,0,0,0.15)")}
        };
    }

    emit paletteChanged();
}
