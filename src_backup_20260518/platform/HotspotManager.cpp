#include "HotspotManager.h"

#ifdef Q_OS_WIN
#include <objbase.h>
#endif

#include <QDebug>

namespace Platform {

HotspotManager::HotspotManager(QObject *parent)
    : QObject(parent)
{
}

HotspotManager::~HotspotManager()
{
#ifdef Q_OS_WIN
    if (m_combase) {
        FreeLibrary(m_combase);
        m_combase = nullptr;
    }
#endif
}

bool HotspotManager::ensureLoaded()
{
    if (m_initialized) return true;

#ifdef Q_OS_WIN
    m_combase = LoadLibraryW(L"combase.dll");
    if (!m_combase) {
        qWarning() << "热点：combase.dll 加载失败";
        return false;
    }

    m_pRoGetActivationFactory = reinterpret_cast<PFN_RoGetActivationFactory>(
        GetProcAddress(m_combase, "RoGetActivationFactory"));
    m_pWindowsCreateString = reinterpret_cast<PFN_WindowsCreateString>(
        GetProcAddress(m_combase, "WindowsCreateString"));
    m_pWindowsDeleteString = reinterpret_cast<PFN_WindowsDeleteString>(
        GetProcAddress(m_combase, "WindowsDeleteString"));

    if (!m_pRoGetActivationFactory || !m_pWindowsCreateString || !m_pWindowsDeleteString) {
        qWarning() << "热点：WinRT 函数获取失败";
        FreeLibrary(m_combase);
        m_combase = nullptr;
        return false;
    }

    m_initialized = true;
    return true;
#else
    return false;
#endif
}

bool HotspotManager::isAvailable()
{
    return ensureLoaded();
}

int HotspotManager::waitAsyncComplete(IInspectable *pAsyncOp, int timeoutMs)
{
#ifdef Q_OS_WIN
    if (!pAsyncOp) return -1;

    auto *pInfo = reinterpret_cast<IAsyncInfo*>(pAsyncOp);
    INT32 status = 0;
    int waited = 0;

    while (waited < timeoutMs) {
        HRESULT hr = pInfo->lpVtbl->get_Status(pInfo, &status);
        if (FAILED(hr)) {
            qWarning() << "热点：get_Status 失败 hr=" << Qt::hex << hr;
            return -1;
        }
        // WinRT AsyncStatus: 0=Started, 1=Completed, 2=Canceled, 3=Error
        if (status == 1) return 0;   // Completed
        if (status == 2) return 2;   // Canceled
        if (status == 3) return 3;   // Error

        Sleep(250);
        waited += 250;
    }

    qDebug() << "热点：轮询超时，进行二次验证";
    return -2;  // Timeout
#else
    Q_UNUSED(pAsyncOp)
    Q_UNUSED(timeoutMs)
    return -1;
#endif
}

int HotspotManager::verifyHotspotOn()
{
#ifdef Q_OS_WIN
    if (!ensureLoaded()) return -1;

    CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

    HSTRING hs1 = nullptr, hs2 = nullptr;
    INetworkInformationStatics *pNI = nullptr;
    ITetheringManagerStatics *pTM = nullptr;
    IInspectable *pProf = nullptr;
    ITetheringManager *pMgr = nullptr;
    INT32 state = -1;

    m_pWindowsCreateString(
        L"Windows.Networking.Connectivity.NetworkInformation", 50, &hs1);
    HRESULT hr = m_pRoGetActivationFactory(hs1, IID_INetworkInformationStatics,
                                            reinterpret_cast<void**>(&pNI));
    m_pWindowsDeleteString(hs1);

    if (SUCCEEDED(hr)) {
        hr = pNI->lpVtbl->GetInternetConnectionProfile(pNI, &pProf);
    }
    if (SUCCEEDED(hr) && pProf) {
        m_pWindowsCreateString(
            L"Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager",
            67, &hs2);
        hr = m_pRoGetActivationFactory(hs2, IID_INetworkOperatorTetheringManagerStatics,
                                        reinterpret_cast<void**>(&pTM));
        m_pWindowsDeleteString(hs2);
    }
    if (SUCCEEDED(hr) && pTM) {
        hr = pTM->lpVtbl->CreateFromConnectionProfile(pTM, pProf,
                                                        reinterpret_cast<IInspectable**>(&pMgr));
    }
    if (SUCCEEDED(hr) && pMgr) {
        pMgr->lpVtbl->get_TetheringOperationalState(pMgr, &state);
    }

    if (pMgr)        pMgr->lpVtbl->Release(pMgr);
    if (pTM)         pTM->lpVtbl->Release(pTM);
    if (pProf)       pProf->lpVtbl->Release(pProf);
    if (pNI)         pNI->lpVtbl->Release(pNI);

    CoUninitialize();
    return state;
#else
    return -1;
#endif
}

int HotspotManager::processTetheringResult(IInspectable *pAsyncOp)
{
#ifdef Q_OS_WIN
    if (!pAsyncOp) {
        // 无异步句柄，直接做二次验证
        int st = verifyHotspotOn();
        qDebug() << "热点二次验证状态:" << st << "(2=On)";
        return st;
    }

    int st = waitAsyncComplete(pAsyncOp, 15000);
    pAsyncOp->lpVtbl->Release(pAsyncOp);

    // 不管 IAsyncInfo 返回什么，都检查 TetheringOperationalState
    int finalState = verifyHotspotOn();
    qDebug() << "热点最终状态:" << finalState << "(2=On)";
    return finalState;
#else
    Q_UNUSED(pAsyncOp)
    return -1;
#endif
}

bool HotspotManager::start()
{
#ifdef Q_OS_WIN
    if (!ensureLoaded()) {
        qWarning() << "热点：combase.dll 加载失败";
        return false;
    }

    // 使用 STA：WinRT UI 相关 API 需要 STA 才能正确完成异步操作
    CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

    HRESULT hr = S_OK;
    HSTRING hsNetInfo = nullptr, hsTethMgr = nullptr;
    INetworkInformationStatics *pNetInfo = nullptr;
    ITetheringManagerStatics  *pTethStatics = nullptr;
    IInspectable *pProfile = nullptr;
    ITetheringManager *pMgr = nullptr;

    // 1. 获取 NetworkInformation statics
    m_pWindowsCreateString(
        L"Windows.Networking.Connectivity.NetworkInformation", 50, &hsNetInfo);
    hr = m_pRoGetActivationFactory(hsNetInfo, IID_INetworkInformationStatics,
                                    reinterpret_cast<void**>(&pNetInfo));
    m_pWindowsDeleteString(hsNetInfo);
    if (FAILED(hr)) {
        qWarning() << "热点：NetworkInformation 激活失败";
        goto cleanup;
    }

    // 2. GetInternetConnectionProfile
    hr = pNetInfo->lpVtbl->GetInternetConnectionProfile(pNetInfo, &pProfile);
    if (FAILED(hr) || !pProfile) {
        qWarning() << "热点：GetInternetConnectionProfile 失败";
        goto cleanup;
    }

    // 3. 获取 NetworkOperatorTetheringManager statics
    m_pWindowsCreateString(
        L"Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager",
        67, &hsTethMgr);
    hr = m_pRoGetActivationFactory(hsTethMgr, IID_INetworkOperatorTetheringManagerStatics,
                                    reinterpret_cast<void**>(&pTethStatics));
    m_pWindowsDeleteString(hsTethMgr);
    if (FAILED(hr)) {
        qWarning() << "热点：TetheringManager 激活失败";
        goto cleanup;
    }

    // 4. CreateFromConnectionProfile
    hr = pTethStatics->lpVtbl->CreateFromConnectionProfile(pTethStatics, pProfile,
                                                             reinterpret_cast<IInspectable**>(&pMgr));
    if (FAILED(hr) || !pMgr) {
        qWarning() << "热点：CreateFromConnectionProfile 失败";
        goto cleanup;
    }

    // 5. 检查当前状态（2=On，直接跳过）
    {
        INT32 state = 0;
        pMgr->lpVtbl->get_TetheringOperationalState(pMgr, &state);
        if (state == 2) {
            qDebug() << "热点已在运行，无需再开启";
            goto cleanup;
        }
    }

    // 6. StartTetheringAsync
    {
        IInspectable *pAsyncOp = nullptr;
        hr = pMgr->lpVtbl->StartTetheringAsync(pMgr, &pAsyncOp);
        if (FAILED(hr)) {
            qWarning() << "热点：StartTetheringAsync 失败";
        } else {
            qDebug() << "热点：StartTetheringAsync 已调用，等待完成...";
            processTetheringResult(pAsyncOp);
        }
    }

cleanup:
    if (pMgr)        pMgr->lpVtbl->Release(pMgr);
    if (pTethStatics) pTethStatics->lpVtbl->Release(pTethStatics);
    if (pProfile)    pProfile->lpVtbl->Release(pProfile);
    if (pNetInfo)    pNetInfo->lpVtbl->Release(pNetInfo);
    CoUninitialize();
    return true;
#else
    return false;
#endif
}

} // namespace Platform
