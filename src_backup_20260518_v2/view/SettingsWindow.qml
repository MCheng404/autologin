import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "Cards"
import "Components"

// 使用内联 SVG 的 Lucide 风格图标
// 如需更多图标，在 Components/LucideIcon.qml 中添加 path 数据

/**
 * 设置窗口：4 张卡片布局
 *
 * 所有颜色均通过 themeVM.palette 获取，支持亮暗主题切换
 * 主题模式：Dark / Light / System（跟随系统）
 */
Window {
    id: settingsWindow

    width: 480
    height: 680
    minimumWidth: 420
    minimumHeight: 580
    flags: Qt.Window | Qt.WindowStaysOnTopHint

    // ViewModel 绑定（由 Main.qml 注入）
    required property var authVM
    required property var settingsVM
    required property var themeVM

    // 背景色跟随主题
    color: themeVM.palette.background

    // 居中显示
    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2

    // 主题切换时平滑过渡
    Behavior on color {
        ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
    }

    // 内容区域
    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: 28
        spacing: 20

        // 标题栏（可拖拽）
        RowLayout {
            Layout.fillWidth: true
            spacing: 14

            // 应用图标
            Rectangle {
                width: 42
                height: 42
                radius: 12
                color: themeVM.palette.primary

                LucideIcon {
                    anchors.centerIn: parent
                    name: "shield-check"
                    color: themeVM.palette.onPrimary
                    size: 22
                }

                Behavior on color {
                    ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
                }
            }

            // 标题文字
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: "校园网自动登录"
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    renderType: Text.NativeRendering
                    font.hintingPreference: Font.PreferFullHinting
                    color: themeVM.palette.textPrimary

                    Behavior on color {
                        ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
                    }
                }

                Text {
                    text: "设置 · v2.12"
                    font.pixelSize: 12
                    renderType: Text.NativeRendering
                    font.hintingPreference: Font.PreferFullHinting
                    color: themeVM.palette.textTertiary

                    Behavior on color {
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
                    ColorAnimation { duration: 150 }
                }

                MouseArea {
                    id: closeMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: settingsWindow.hide()
                }

                DragHandler {
                    target: null
                    onTranslationChanged: {
                        settingsWindow.x += translation.x
                        settingsWindow.y += translation.y
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
                ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
            }
        }

        // 卡片区域（可滚动）
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            // ScrollView 不支持直接放 Layout，需用 Item 包裹
            Item {
                width: parent.width
                implicitHeight: cardCol.implicitHeight + 32

                ColumnLayout {
                    id: cardCol
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 16
                    spacing: 16

                    BasicSettingsCard {
                        Layout.fillWidth: true
                        settingsVM: settingsWindow.settingsVM
                        themeVM: settingsWindow.themeVM
                    }

                    NetworkSettingsCard {
                        Layout.fillWidth: true
                        settingsVM: settingsWindow.settingsVM
                        themeVM: settingsWindow.themeVM
                    }

                    ScheduleCard {
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

        // 底部按钮
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            // 取消按钮
            Rectangle {
                id: cancelBtn
                Layout.fillWidth: true
                height: 44
                radius: 12
                color: cancelMouseArea.containsMouse ? themeVM.palette.hoverBackground : themeVM.palette.surfaceVariant
                border.color: themeVM.palette.outline
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "取消"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    renderType: Text.NativeRendering
                    font.hintingPreference: Font.PreferFullHinting
                    color: themeVM.palette.textSecondary
                }

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
                Behavior on border.color {
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
                height: 44
                radius: 12
                color: saveMouseArea.containsMouse ? themeVM.palette.primaryHover : themeVM.palette.primary

                Text {
                    anchors.centerIn: parent
                    text: "保存"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    renderType: Text.NativeRendering
                    font.hintingPreference: Font.PreferFullHinting
                    color: themeVM.palette.onPrimary
                }

                Behavior on color {
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
