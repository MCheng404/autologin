import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "Cards"
import "Components"

/**
 * 设置窗口：4 张卡片布局
 */
Window {
    id: settingsWindow

    width: 460
    height: 640
    flags: Qt.Window | Qt.WindowStaysOnTopHint

    // ViewModel 绑定（由 Main.qml 注入）
    required property var authVM
    required property var settingsVM
    required property var themeVM

    // 背景色（先确保窗口可见，后续再加毛玻璃）
    color: "#1a1a2e"

    // 居中显示
    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2

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

            // 图标
            Rectangle {
                width: 42
                height: 42
                radius: 12
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#6366f1" }
                    GradientStop { position: 1.0; color: "#818cf8" }
                }

                Text {
                    anchors.centerIn: parent
                    text: "🔐"
                    font.pixelSize: 22
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
                    color: "#e2e8f0"
                }

                Text {
                    text: "设置 · v2.12"
                    font.pixelSize: 12
                    color: "#94a3b8"
                }
            }

            // 主题切换按钮
            ThemeToggle {
                isDark: themeVM.isDark
                onToggleClicked: themeVM.toggle()
            }

            // 关闭按钮
            Rectangle {
                width: 32
                height: 32
                radius: 8
                color: closeMouseArea.containsMouse ? "#334155" : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    font.pixelSize: 14
                    color: "#94a3b8"
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
            color: "#334155"
        }

        // 卡片区域（可滚动）
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: mainLayout.width - 56
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

        // 底部按钮
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            // 取消按钮
            Rectangle {
                Layout.fillWidth: true
                height: 44
                radius: 12
                color: "#334155"
                border.color: "#475569"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "取消"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    color: "#94a3b8"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: settingsWindow.hide()
                }
            }

            // 保存按钮
            Rectangle {
                Layout.fillWidth: true
                height: 44
                radius: 12
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#6366f1" }
                    GradientStop { position: 1.0; color: "#818cf8" }
                }

                Text {
                    anchors.centerIn: parent
                    text: "保存"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    color: "#ffffff"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        settingsVM.save()
                        settingsWindow.hide()
                    }
                }
            }
        }
    }
}
