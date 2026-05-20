#pragma once

#include <QObject>

#ifdef Q_OS_WIN
#include "Win32Defs.h"
#endif

namespace Platform {

/**
 * @brief WinRT 热点管理（延迟加载 combase.dll）
 *
 * 使用 WinRT COM vtable 手动调用 NetworkOperatorTetheringManager
 * 不依赖 C++/WinRT 头文件，通过 LoadLibraryW("combase.dll") 延迟加载
 */
class HotspotManager : public QObject {
    Q_OBJECT

public:
    explicit HotspotManager(QObject *parent = nullptr);
    ~HotspotManager();

    /** 启动移动热点，返回 true 表示成功触发 */
    bool start();

    /** 检测热点功能是否可用 */
    bool isAvailable();

    /** 验证热点当前状态（返回 TetheringOperationalState: 2=On） */
    int verifyState();

private:
    /** 延迟加载 combase.dll 并获取函数指针 */
    bool ensureLoaded();

    /** 处理异步操作结果 */
    int processTetheringResult(IInspectable *pAsyncOp);

    /** 等待异步操作完成 */
    int waitAsyncComplete(IInspectable *pAsyncOp, int timeoutMs);

    /** 二次验证热点状态 */
    int verifyHotspotOn();

private:
#ifdef Q_OS_WIN
    HMODULE m_combase = nullptr;
#endif
    bool m_initialized = false;

    // WinRT 函数指针缓存
    PFN_RoGetActivationFactory m_pRoGetActivationFactory = nullptr;
    PFN_WindowsCreateString     m_pWindowsCreateString     = nullptr;
    PFN_WindowsDeleteString     m_pWindowsDeleteString     = nullptr;
};

} // namespace Platform
