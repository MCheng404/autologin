# AutoLogin - 校园网自动登录工具

![](https://img.shields.io/badge/C%2B%2B-17-blue) ![](https://img.shields.io/badge/Qt-6.11-green) ![](https://img.shields.io/badge/Platform-Windows%2010%2F11-blueviolet) ![](https://img.shields.io/badge/Version-2.12-purple)

一款简洁高效的校园网 HTTP 认证自动登录工具，基于 C++17 + Qt6 QML 构建，MVVM 架构，毛玻璃卡片 UI。

---

## 功能特性

| 功能 | 说明 |
|------|------|
| **自动登录** | 检测断网后自动重连，指数退避重试（最大 5 分钟） |
| **认证防抖** | 网络抖动时 3 秒窗口内只发起一次认证请求 |
| **黑名单时段** | 凌晨 03:55–05:05 自动跳过认证（可配置） |
| **定时检测** | 支持配置检测间隔（默认 30s），可设偏移量 |
| **移动热点** | 自动管理 Windows 移动热点（WinRT COM） |
| **托盘运行** | 系统托盘气泡通知，最小化后台 |
| **主题切换** | Dark / Light / System 三态，16 种主题色 + Flow 流动渐变 |
| **毛玻璃卡片** | 纯色 GlassCard 组件 + 主题色发光阴影 + 文字阴影 |
| **自定义字体** | LXGW Neo XiHei Plus（中文）+ Inter（英文）+ JetBrains Mono（数字） |
| **日志管理** | 自动清理 7 天前日志，日切割 |
| **自启动** | 注册表自启动设置 |

---

## UI 组件

| 组件 | 文件 | 说明 |
|------|------|------|
| `GlassCard` | `src/view/Components/GlassCard.qml` | 毛玻璃卡片根组件，主题色持久发光阴影 + 悬停描边 |
| `ShadowText` | `src/view/Components/ShadowText.qml` | 带主题色偏移阴影的文字组件 |
| `SwitchToggle` | `src/view/Components/SwitchToggle.qml` | 弹性动画开关 |
| `ColorDot` | `src/view/Components/ColorDot.qml` | 16 色主题选择圆点（22px） |
| `ThemeToggle` | `src/view/Components/ThemeToggle.qml` | Dark/Light/System 三态切换 |
| `FloatingScrollBar` | `src/view/Components/FloatingScrollBar.qml` | 浮动滚动条 |

### 卡片列表

| 卡片 | 说明 |
|------|------|
| `BasicSettingsCard` | 基本功能：点击认证 / 自启 / 通知 / 通知位置 |
| `SystemStatusCard` | 系统状态：实时时钟 / 运行时间 / 距上次认证 |
| `NetworkSettingsCard` | 网络设置：自动热点 / 线程优先级 |
| `ScheduleCard` | 定时认证：开关 / 间隔 / 偏移 |
| `AccountCard` | 账户信息：用户名 / 密码（自动补 @unicom） |
| `AccentColorCard` | 主题色彩：16 色选择 + Flow 流动渐变按钮 |

---

## 技术架构

```
src/
├── model/           # AuthEngine, ConnectivityChecker, Scheduler, Logger, Settings
├── viewmodel/       # AuthViewModel, SettingsViewModel, TrayViewModel, ThemeViewModel
├── view/            # QML (Main, SettingsWindow, 6 Cards, 10 Components)
└── platform/        # NetworkAdapter, Registry, HotspotManager, Notification, SystemTray
```

| 层 | 职责 |
|----|------|
| Model | 业务逻辑，纯 C++ |
| ViewModel | Q_PROPERTY 绑定，跨线程 UI 更新 |
| View | QML 声明式 UI，毛玻璃卡片 |
| Platform | Win32/WinRT API 隔离 |

---

## 构建

### 环境要求

- Qt 6.11+ (Qt Quick, Qt Network, Qt Widgets)
- CMake 3.21+
- Ninja 构建工具
- llvm-mingw 或 MinGW-w64

### 编译 (llvm-mingw, 推荐)

```bash
mkdir build && cd build
cmake .. -G "Ninja" \
  -DCMAKE_PREFIX_PATH=D:/Qt/6.11.1/llvm-mingw_64 \
  -DCMAKE_CXX_COMPILER=D:/Qt/Tools/llvm-mingw1706_64/bin/clang++.exe \
  -DCMAKE_MAKE_PROGRAM=E:/Tools/ninja/ninja.exe
ninja
windeployqt --no-translations AutoLogin.exe
```

### 编译 (MinGW)

```bash
mkdir build && cd build
cmake .. -G "Ninja" \
  -DCMAKE_PREFIX_PATH=D:/Qt/6.11.1/mingw_64 \
  -DCMAKE_CXX_COMPILER=D:/Qt/Tools/mingw1310_64/bin/g++.exe \
  -DCMAKE_MAKE_PROGRAM=E:/Tools/ninja/ninja.exe
ninja
```

---

## 字体

| 字体 | 用途 | 许可 |
|------|------|------|
| [LXGW Neo XiHei Plus](https://github.com/lxgw/LxgwNeoXiHei) | 中文 UI | SIL OFL |
| [Inter](https://rsms.me/inter/) | 英文 UI | SIL OFL |
| [JetBrains Mono](https://www.jetbrains.com/lp/mono/) | 数字 / 等宽 | SIL OFL |

---

## 配置

### 默认参数

| 参数 | 默认值 | 说明 |
|------|--------|------|
| 网关地址 | `172.30.255.2` | 认证服务器 |
| 检测地址 | `connect.rom.miui.com` | 连通性检测 |
| 检测间隔 | 30s | 网络状态检查周期 |
| 重试上限 | 300s | 指数退避最大延迟 |
| 黑名单 | 03:55-05:05 | 跳过认证时段 |

---

## 开源许可

仅供学习和交流使用，请遵守校园网使用规范。
