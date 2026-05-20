#pragma once

#include <QObject>
#include <QString>
#include "model/Settings.h"

/**
 * @brief 设置项暴露给 QML（双向绑定）
 *
 * 所有 Q_PROPERTY 与 Settings 模型一一对应
 * QML 修改属性 → ViewModel 更新 Settings → 注册表持久化
 */
class SettingsViewModel : public QObject {
    Q_OBJECT

    Q_PROPERTY(bool clickToAuth READ clickToAuth WRITE setClickToAuth NOTIFY clickToAuthChanged)
    Q_PROPERTY(bool autostart READ autostart WRITE setAutostart NOTIFY autostartChanged)
    Q_PROPERTY(bool notifications READ notifications WRITE setNotifications NOTIFY notificationsChanged)
    Q_PROPERTY(bool autoHotspot READ autoHotspot WRITE setAutoHotspot NOTIFY autoHotspotChanged)
    Q_PROPERTY(bool highPriority READ highPriority WRITE setHighPriority NOTIFY highPriorityChanged)
    Q_PROPERTY(bool schedEnabled READ schedEnabled WRITE setSchedEnabled NOTIFY schedEnabledChanged)
    Q_PROPERTY(int schedInterval READ schedInterval WRITE setSchedInterval NOTIFY schedIntervalChanged)
    Q_PROPERTY(int schedOffset READ schedOffset WRITE setSchedOffset NOTIFY schedOffsetChanged)
    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)

public:
    explicit SettingsViewModel(Settings *settings, QObject *parent = nullptr);

    // === Getters（委托给 Settings） ===
    bool clickToAuth() const { return m_settings->clickToAuth(); }
    bool autostart() const { return m_settings->autostart(); }
    bool notifications() const { return m_settings->notifications(); }
    bool autoHotspot() const { return m_settings->autoHotspot(); }
    bool highPriority() const { return m_settings->highPriority(); }
    bool schedEnabled() const { return m_settings->schedEnabled(); }
    int schedInterval() const { return m_settings->schedInterval(); }
    int schedOffset() const { return m_settings->schedOffset(); }
    QString username() const { return m_settings->username(); }
    QString password() const { return m_settings->password(); }

    // === Setters（委托给 Settings） ===
    void setClickToAuth(bool v) { m_settings->setClickToAuth(v); }
    void setAutostart(bool v) { m_settings->setAutostart(v); }
    void setNotifications(bool v) { m_settings->setNotifications(v); }
    void setAutoHotspot(bool v) { m_settings->setAutoHotspot(v); }
    void setHighPriority(bool v) { m_settings->setHighPriority(v); }
    void setSchedEnabled(bool v) { m_settings->setSchedEnabled(v); }
    void setSchedInterval(int v) { m_settings->setSchedInterval(v); }
    void setSchedOffset(int v) { m_settings->setSchedOffset(v); }
    void setUsername(const QString &v) { m_settings->setUsername(v); }
    void setPassword(const QString &v) { m_settings->setPassword(v); }

    /** QML 调用：保存设置到注册表 */
    Q_INVOKABLE void save();

    /** QML 调用：从注册表重新加载设置 */
    Q_INVOKABLE void load();

    /** QML 调用：重置为默认值 */
    Q_INVOKABLE void resetDefaults();

signals:
    void clickToAuthChanged();
    void autostartChanged();
    void notificationsChanged();
    void autoHotspotChanged();
    void highPriorityChanged();
    void schedEnabledChanged();
    void schedIntervalChanged();
    void schedOffsetChanged();
    void usernameChanged();
    void passwordChanged();

    /** 设置已保存信号 */
    void settingsSaved();

private:
    Settings *m_settings = nullptr;
};
