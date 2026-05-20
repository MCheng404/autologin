#include "ThemeViewModel.h"

#include <QGuiApplication>
#include <QStyleHints>

// 16 种主题色（索引 0-15）
static const QVariantList INIT_ACCENT_COLORS() {
    return QVariantList {
        QVariant(QStringLiteral("#ec4899")),  // 0  粉红（默认）
        QVariant(QStringLiteral("#f43f5e")),  // 1  玫红
        QVariant(QStringLiteral("#e11d48")),  // 2  深玫红
        QVariant(QStringLiteral("#f97316")),  // 3  橙色
        QVariant(QStringLiteral("#eab308")),  // 4  黄色
        QVariant(QStringLiteral("#84cc16")),  // 5  青柠
        QVariant(QStringLiteral("#22c55e")),  // 6  绿色
        QVariant(QStringLiteral("#10b981")),  // 7  翠绿
        QVariant(QStringLiteral("#14b8a6")),  // 8  青色
        QVariant(QStringLiteral("#06b6d4")),  // 9  浅蓝
        QVariant(QStringLiteral("#0ea5e9")),  // 10 蓝色
        QVariant(QStringLiteral("#3b82f6")),  // 11 钴蓝
        QVariant(QStringLiteral("#6366f1")),  // 12 靛蓝
        QVariant(QStringLiteral("#8b5cf6")),  // 13 紫色
        QVariant(QStringLiteral("#a855f7")),  // 14 洋红
        QVariant(QStringLiteral("#d946ef")),  // 15 紫红
    };
}

ThemeViewModel::ThemeViewModel(Settings *settings, QObject *parent)
    : QObject(parent)
    , m_settings(settings)
    , m_themeMode(settings->theme())
    , m_systemIsDark(detectSystemDark())
    , m_accentColorIndex(settings->accentColor())
    , m_accentColors(INIT_ACCENT_COLORS())
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

    // 监听 Settings 的 accentColor 变化
    connect(m_settings, &Settings::accentColorChanged, this, [this]() {
        int idx = m_settings->accentColor();
        if (m_accentColorIndex != idx) {
            m_accentColorIndex = idx;
            updatePalette();
            emit accentColorIndexChanged();
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
    QString accent = m_accentColors.value(m_accentColorIndex).toString();

    if (m_isDark) {
        m_palette = {
            {QStringLiteral("background"),       QStringLiteral("#0f0f1a")},
            {QStringLiteral("surface"),           QStringLiteral("#1a1a2e")},
            {QStringLiteral("surfaceVariant"),    QStringLiteral("#252540")},
            {QStringLiteral("primary"),            accent},
            {QStringLiteral("primaryHover"),      accent},
            {QStringLiteral("primaryContainer"),  accent + QStringLiteral("33")},
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
            {QStringLiteral("toggleActive"),       accent},
            {QStringLiteral("inputBackground"),    QStringLiteral("#16162a")},
            {QStringLiteral("inputBorder"),         QStringLiteral("#2d2d4a")},
            {QStringLiteral("inputFocusBorder"),   accent},
            {QStringLiteral("divider"),             QStringLiteral("#1e293b")},
            {QStringLiteral("hoverBackground"),    QStringLiteral("#1e293b")},
            {QStringLiteral("cardShadow"),        QStringLiteral("#00000040")},
            {QStringLiteral("closeHover"),         QStringLiteral("#334155")},
            {QStringLiteral("overlay"),             QStringLiteral("#00000080")},

            // ── Liquid Glass ──
            {QStringLiteral("glassSurface"),        QStringLiteral("#ffffff18")},   // 卡片玻璃面
            {QStringLiteral("glassSurfaceLight"),   QStringLiteral("#ffffff30")},   // 玻璃高光
            {QStringLiteral("glassBorder"),         QStringLiteral("#ffffff22")},   // 玻璃边框
            {QStringLiteral("glassInner"),          QStringLiteral("#ffffff14")},   // 玻璃内壁
            {QStringLiteral("glassRefract"),        QStringLiteral("#a78bfa40")},  // 折射色（淡紫）
            {QStringLiteral("glassShine"),          QStringLiteral("#ffffff0f")}    // 顶部光泽
        };
    } else {
        m_palette = {
            {QStringLiteral("background"),       QStringLiteral("#f8fafc")},
            {QStringLiteral("surface"),           QStringLiteral("#ffffff")},
            {QStringLiteral("surfaceVariant"),    QStringLiteral("#f1f5f9")},
            {QStringLiteral("primary"),            accent},
            {QStringLiteral("primaryHover"),      accent},
            {QStringLiteral("primaryContainer"),  accent + QStringLiteral("22")},
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
            {QStringLiteral("cardShadow"),        QStringLiteral("#0f172a1a")},
            {QStringLiteral("toggleTrack"),        QStringLiteral("#cbd5e1")},
            {QStringLiteral("toggleActive"),       accent},
            {QStringLiteral("inputBackground"),    QStringLiteral("#f8fafc")},
            {QStringLiteral("inputBorder"),         QStringLiteral("#e2e8f0")},
            {QStringLiteral("inputFocusBorder"),   accent},
            {QStringLiteral("divider"),             QStringLiteral("#e2e8f0")},
            {QStringLiteral("hoverBackground"),    QStringLiteral("#f1f5f9")},
            {QStringLiteral("closeHover"),         QStringLiteral("#fee2e2")},
            {QStringLiteral("overlay"),             QStringLiteral("#00000026")},

            // ── Liquid Glass ──
            {QStringLiteral("glassSurface"),        QStringLiteral("#ffffffa0")},
            {QStringLiteral("glassSurfaceLight"),   QStringLiteral("#ffffffd0")},
            {QStringLiteral("glassBorder"),         QStringLiteral("#ffffffcc")},
            {QStringLiteral("glassInner"),          QStringLiteral("#f8fafc50")},
            {QStringLiteral("glassRefract"),        QStringLiteral("#818cf820")},
            {QStringLiteral("glassShine"),          QStringLiteral("#ffffff60")}
        };
    }

    emit paletteChanged();
}

void ThemeViewModel::setAccentColorIndex(int index)
{
    index = qBound(0, index, 15);
    if (m_accentColorIndex == index) return;

    m_accentColorIndex = index;
    m_settings->setAccentColor(index);
    updatePalette();
    emit accentColorIndexChanged();
}
