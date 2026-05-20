#include "ConnectivityChecker.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>
#include <QTimer>
#include <QUrl>

ConnectivityChecker::ConnectivityChecker(QObject *parent)
    : QObject(parent)
    // m_nam 不在此处创建：check() 可能被工作线程调用，
    // QNetworkAccessManager 必须在实际调用线程中创建和使用。
{
}

bool ConnectivityChecker::check()
{
    // 在当前调用线程创建局部 QNAM（避免跨线程使用主线程的成员 QNAM）
    QNetworkAccessManager nam;

    QEventLoop loop;
    QNetworkRequest request(QUrl(QStringLiteral("http://connect.rom.miui.com/generate_204")));
    request.setTransferTimeout(5000); // 5 秒超时

    QTimer::singleShot(5000, &loop, &QEventLoop::quit);
    QNetworkReply *reply = nam.get(request);
    connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    loop.exec();

    int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    reply->deleteLater();

    return (status == 204);
}
