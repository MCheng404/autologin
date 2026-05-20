# AutoLogin - 校园网自动登录工具

![](https://img.shields.io/badge/C%2B%2B-17-blue) ![](https://img.shields.io/badge/Qt-6.11-green) ![](https://img.shields.io/badge/Platform-Windows%2010%2F11-blueviolet)

一款简洁高效的校园网 HTTP 认证自动登录工具，基于 C++17 + Qt6 QML 构建，支持 MVVM 架构。

---

## 功能特性

| 功能 | 说明 |
|------|------|
| **自动登录** | 检测断网后自动重连，指数退避重试（最大 5 分钟） |
| **认证防抖** | 网络抖动时 3 秒窗口内只发起一次认证请求 |
| **黑名单时段** | 凌晨 03:55–05:05 自动跳过认证（可配置） |
| **定时检测** | 支持配置检测间隔（默认 30s） |
| **移动热点** | 自动管理 Windows 移动热点（WinRT COM） |
| **托盘运行** | 系统托盘气泡通知，最小化后台 |
| **主题切换** | 深色/浅色主题，流畅动画过渡 |
| **毛玻璃 UI** | Mica/Acrylic 视觉降级支持 |
| **日志管理** | 自动清理 7 天前日志，支持日志级别配置 |
| **自启动** | 注册表自启动设置 |

---

## 技术架构

```
src/
├── model/           # 业务模型（AuthEngine, ConnectivityChecker, Scheduler, Logger, Settings）
├── viewmodel/       # 视图模型（AuthViewModel, SettingsViewModel, TrayViewModel, ThemeViewModel）
├── view/            # QML 界面（Main, SettingsWindow, Cards, Components）
└── platform/        # 平台隔离层（NetworkAdapter, Registry, HotspotManager, Notification, SystemTray）

Architecture: MVVM 四层分离
Build System: CMake + Ninja
UI Framework: Qt6 QML
MinGW: 13.1.0
```

---

## 构建

### 环境要求

- Qt 6.11+ (包含 Qt Quick, Qt Network, Qt Widgets)
- CMake 3.21+
- Ninja 构建工具
- MinGW-w64 (GCC 13.1.0)

### 编译步骤

```bash
# 配置
mkdir build && cd build
cmake .. -G "Ninja" \
  -DCMAKE_PREFIX_PATH=E:/Qt/6.11.1/mingw_64 \
  -DCMAKE_CXX_COMPILER=E:/Qt/Tools/mingw1310_64/bin/g++.exe \
  -DCMAKE_MAKE_PROGRAM=E:/Qt/Tools/Ninja/ninja.exe

# 编译
cmake --build . --config Release

# 部署 Qt 依赖
E:/Qt/6.11.1/mingw_64/bin/windeployqt.exe --no-translations AutoLogin.exe
```

---

## 配置

### 账号

- 支持记住密码
- ISP 后缀自动补全（`@unicom` 等）
- 用户名/密码本地加密存储

### 网络

| 参数 | 默认值 | 说明 |
|------|--------|------|
| 网关地址 | `172.30.255.2` | 认证服务器 |
| 检测地址 | `connect.rom.miui.com` | 连通性检测 |
| 检测间隔 | 30s | 网络状态检查周期 |
| 重试上限 | 300s | 指数退避最大延迟 |

### 定时计划

- 支持设置每周/每日的禁用时段
- 黑名单时段内暂停所有网络检测和认证

---

## 开源许可

本项目仅供学习和交流使用，请遵守校园网使用规范。
