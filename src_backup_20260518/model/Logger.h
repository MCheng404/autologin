#pragma once

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QMutex>
#include <QString>
#include <QDate>

/**
 * @brief 线程安全文件日志 + 7天自动清理
 *
 * 日志目录：%APPDATA%/AutoLogin/logs/
 * 文件名格式：autologin_YYYYMMDD.log
 * 7 天自动清理，支持手动清理按钮
 */
class Logger : public QObject {
    Q_OBJECT

public:
    explicit Logger(QObject *parent = nullptr);
    ~Logger();

    /** 写入日志消息（线程安全） */
    void log(const QString &msg);

    /** 自动清理超过 7 天的日志文件 */
    void autoCleanup();

    /** 手动清理所有日志文件，返回 true 表示清理成功 */
    bool manualCleanup();

    /** 获取日志目录路径 */
    QString logPath() const;

signals:
    /** 新日志消息信号 */
    void logMessage(const QString &msg);

private:
    /** 确保日志目录存在并打开当天的日志文件 */
    void ensureLogFile();

    QFile       m_logFile;
    QString     m_logPath;
    QDate       m_currentDate;
    QMutex      m_mutex;
};
