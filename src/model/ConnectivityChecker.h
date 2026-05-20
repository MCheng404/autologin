#pragma once

#include <QObject>

/**
 * @brief 互联网连通性检测（HTTP 204）
 *
 * 向 http://connect.rom.miui.com/generate_204 发送 GET 请求
 * 仅 HTTP 204 视为连通，超时 5 秒
 *
 * 注意：check() 可能在工作线程调用，QNetworkAccessManager
 * 在函数内部创建（栈对象），避免跨线程使用。
 */
class ConnectivityChecker : public QObject {
    Q_OBJECT

public:
    explicit ConnectivityChecker(QObject *parent = nullptr);

    /** 同步检测连通性（阻塞，适用于 Worker Thread） */
    bool check();
    // 不持有 m_nam 成员：check() 内部创建局部 QNAM 避免跨线程
};
