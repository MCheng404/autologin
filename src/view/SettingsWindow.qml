import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "Cards"
import "Components"

/**
 * 设置窗口：4 张卡片 + 主题色选择
 *
 * 所有颜色均通过 themeVM.palette 获取，支持亮暗主题切换
 * 主题模式：Dark / Light / System（跟随系统）
 */
Window {
    id: settingsWindow

    width: 640
    height: 640
    minimumWidth: 560
    minimumHeight: 560
    // 无边框窗口，自己实现拖拽和关闭按钮
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    // 背景透明（DWM 圆角遮罩由 C++ DwmSetWindowAttribute 处理）
    // 透明背景让 shadow 溢出部分透出桌面
    color: "transparent"

    // ViewModel 绑定（由 Main.qml 注入）
    required property var authVM
    required property var settingsVM
    required property var themeVM
    required property var trayVM

    // 居中显示
    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2

    // 圆角遮罩由 Main.qml Loader.onLoaded 调用 app.applyWindowMask() 设置

    // ============================================================
    // 抗闪烁：resize 时暂停所有动画
    // ============================================================
    property bool isResizing: false

    onWidthChanged: {
        isResizing = true
        resizeTimer.restart()
    }
    onHeightChanged: {
        isResizing = true
        resizeTimer.restart()
    }

    Timer {
        id: resizeTimer
        interval: 200
        onTriggered: isResizing = false
    }

    // ============================================================
    // 窗口主体
    // shadow offset=6 + radius=14，在窗口内（DWM 8px 圆角范围内）
    // 效果等同于窗口内壁深色描边（inset shadow）
    //
    // clip: false — shadow（radius=14）超出窗口边界透明不可见，
    //            内部被 windowBgContent（radius=8）覆盖，
    //            圆角完全由 windowBgContent 的 radius=8 决定，
    //            无论亮色/暗色主题表现一致。
    // ============================================================
    Item {
        id: windowBg
        anchors.fill: parent
        clip: false

        // 外层阴影（inset shadow = 内壁深色描边）
        Rectangle {
            x: -6; y: -6
            width: parent.width + 12; height: parent.height + 12
            radius: 14
            color: themeVM.palette.cardShadow

            Behavior on color {
                ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
            }
        }

        // 内容层（radius=8，与 DWM 圆角一致）
        Rectangle {
            id: windowBgContent
            anchors.fill: parent
            radius: 8
            color: themeVM.palette.background

            Behavior on color {
                enabled: !settingsWindow.isResizing
                ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
            }
        }
    }

    // ============================================================
    // 内容区域
    // ============================================================
    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: 20
        spacing: 14

        // 标题栏（可拖拽）
        Item {
            Layout.fillWidth: true
            height: 52

            // 标题栏拖拽区域
            MouseArea {
                anchors.fill: parent
                property real lastX: 0
                property real lastY: 0
                onPressed: {
                    lastX = mouseX
                    lastY = mouseY
                }
                onMouseXChanged: {
                    settingsWindow.x += (mouseX - lastX)
                }
                onMouseYChanged: {
                    settingsWindow.y += (mouseY - lastY)
                }
            }

            RowLayout {
                anchors.fill: parent
                spacing: 14

                // 应用图标（带主题色氛围光晕）
                Rectangle {
                    width: 42
                    height: 42
                    radius: 12

                    // 外层氛围光晕（主题色）
                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width + 16
                        height: parent.height + 16
                        radius: parent.radius + 8
                        color: themeVM.palette.primary
                        opacity: 0.18

                        Behavior on opacity {
                            ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
                        }
                    }

                    // 图标本体
                    Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: themeVM.palette.primary

                        LucideIcon {
                            anchors.centerIn: parent
                            name: "shield-check"
                            color: themeVM.palette.onPrimary
                            size: 22
                        }

                        Behavior on color {
                            enabled: !settingsWindow.isResizing
                            ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
                        }
                    }
                }

                // 标题文字
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: "校园网自动登录"
                        font.pixelSize: 16
                        font.weight: Font.Medium
                        font.family: "Sarasa UI SC, WenQuanYi Rounded SC, WenQuanYi Micro Hei, sans-serif"
                        renderType: Text.NativeRendering
                        font.hintingPreference: Font.PreferFullHinting
                        color: themeVM.palette.textPrimary

                        Behavior on color {
                            enabled: !settingsWindow.isResizing
                            ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
                        }
                    }

                    Text {
                        text: "设置 · v2.12"
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        font.family: "Sarasa UI SC, WenQuanYi Rounded SC, WenQuanYi Micro Hei, sans-serif"
                        renderType: Text.NativeRendering
                        font.hintingPreference: Font.PreferFullHinting
                        color: themeVM.palette.textTertiary

                        Behavior on color {
                            enabled: !settingsWindow.isResizing
                            ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
                        }
                    }
                }

                // 主题切换按钮（三态：Dark/Light/System）
                ThemeToggle {
                    themeMode: themeVM.themeMode
                    isDark: themeVM.isDark
                    onModeClicked: themeVM.toggle()
                }

                // 关闭按钮
                Rectangle {
                    width: 32
                    height: 32
                    radius: 8
                    color: closeMouseArea.containsMouse ? themeVM.palette.closeHover : "transparent"

                    LucideIcon {
                        anchors.centerIn: parent
                        name: "x"
                        size: 16
                        color: closeMouseArea.containsMouse ? "#ef4444" : themeVM.palette.textTertiary
                    }

                    Behavior on color {
                        enabled: !settingsWindow.isResizing
                        ColorAnimation { duration: 150 }
                    }

                    MouseArea {
                        id: closeMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: settingsWindow.hide()
                    }
                }
            }
        }

        // 分隔线
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: themeVM.palette.divider

            Behavior on color {
                enabled: !settingsWindow.isResizing
                ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
            }
        }

        // ============================================================
        // 卡片区域（两列 Grid + 可滚动）
        // ============================================================
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 0

            // 可滚动内容
            Flickable {
                id: flickable
                anchors.left: parent.left
                anchors.right: scrollBar.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 12
                clip: true
                contentWidth: width
                contentHeight: cardRow.implicitHeight + 32

                // ============================================================
                // 两列卡片：左列 + 右列，顶部对齐
                // ============================================================
                RowLayout {
                    id: cardRow
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 14
                    spacing: 14
                    width: flickable.width - 12

                    // 左列
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: false
                        Layout.alignment: Qt.AlignTop
                        spacing: 14

                        BasicSettingsCard {
                            Layout.fillWidth: true
                            settingsVM: settingsWindow.settingsVM
                            themeVM: settingsWindow.themeVM
                        }

                        SystemStatusCard {
                            Layout.fillWidth: true
                            trayVM: settingsWindow.trayVM
                            themeVM: settingsWindow.themeVM
                        }

                        ScheduleCard {
                            Layout.fillWidth: true
                            settingsVM: settingsWindow.settingsVM
                            themeVM: settingsWindow.themeVM
                        }
                    }

                    // 右列
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: false
                        Layout.alignment: Qt.AlignTop
                        spacing: 14

                        NetworkSettingsCard {
                            Layout.fillWidth: true
                            settingsVM: settingsWindow.settingsVM
                            themeVM: settingsWindow.themeVM
                        }

                        AccountCard {
                            Layout.fillWidth: true
                            settingsVM: settingsWindow.settingsVM
                            themeVM: settingsWindow.themeVM
                        }
                    }
                }
            }

            // 滚动条
            FloatingScrollBar {
                id: scrollBar
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 32
                flickable: flickable
                themeVM: settingsWindow.themeVM
            }
        }

        // ============================================================
        // 底部按钮
        // ============================================================
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            // 取消按钮
            Rectangle {
                id: cancelBtn
                Layout.fillWidth: true
                height: 40
                radius: 10
                color: cancelMouseArea.containsMouse ? themeVM.palette.hoverBackground : themeVM.palette.surfaceVariant
                border.color: themeVM.palette.outline
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "取消"
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    font.family: "文泉驿雅黑, WenQuanYi Micro Hei, Microsoft YaHei, sans-serif"
                    renderType: Text.NativeRendering
                    font.hintingPreference: Font.PreferFullHinting
                    color: themeVM.palette.textSecondary
                }

                Behavior on color {
                    enabled: !settingsWindow.isResizing
                    ColorAnimation { duration: 150 }
                }
                Behavior on border.color {
                    enabled: !settingsWindow.isResizing
                    ColorAnimation { duration: 150 }
                }

                MouseArea {
                    id: cancelMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: settingsWindow.hide()
                }
            }

            // 保存按钮
            Rectangle {
                id: saveBtn
                Layout.fillWidth: true
                height: 40
                radius: 10
                color: saveMouseArea.containsMouse ? themeVM.palette.primaryHover : themeVM.palette.primary

                // 悬停外发光
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: saveMouseArea.containsMouse ? -3 : 0
                    radius: parent.radius + (saveMouseArea.containsMouse ? 3 : 0)
                    color: "transparent"
                    border.color: themeVM.palette.primary
                    border.width: 2
                    opacity: saveMouseArea.containsMouse ? 0.5 : 0
                    Behavior on opacity { ColorAnimation { duration: 200 } }
                }

                Text {
                    anchors.centerIn: parent
                    text: "保存"
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    font.family: "文泉驿雅黑, WenQuanYi Micro Hei, Microsoft YaHei, sans-serif"
                    renderType: Text.NativeRendering
                    font.hintingPreference: Font.PreferFullHinting
                    color: themeVM.palette.onPrimary
                }

                Behavior on color {
                    enabled: !settingsWindow.isResizing
                    ColorAnimation { duration: 150 }
                }

                MouseArea {
                    id: saveMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        settingsVM.save()
                        settingsWindow.hide()
                    }
                }
            }
        }
    }
}
